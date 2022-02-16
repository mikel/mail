# encoding: utf-8
# frozen_string_literal: true
require File.expand_path('../environment', __FILE__)

unless defined?(MAIL_ROOT)
  $stderr.puts("Running Specs under Ruby Version #{RUBY_VERSION}")
  MAIL_ROOT = File.join(File.dirname(__FILE__), '../')
end

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.join(File.dirname(__FILE__))
end

unless defined?(MAIL_SPEC_SUITE_RUNNING)
  # Used to force compile all the parsers on each spec suite load
  MAIL_SPEC_SUITE_RUNNING = true
end

require 'rspec'
require File.join(File.dirname(__FILE__), 'matchers', 'break_down_to')

require 'mail'

$stderr.puts("Running Specs for Mail Version #{Mail::VERSION::STRING}")

RSpec.configure do |c|
  c.mock_with :rspec
  c.include(CustomMatchers)

  require 'rspec-benchmark'
  c.include RSpec::Benchmark::Matchers
end

if defined?(Encoding) && Encoding.respond_to?(:default_external=)
  begin
    orig, $VERBOSE = $VERBOSE, nil
    Encoding.default_external = 'utf-8'
  ensure
    $VERBOSE = orig
  end
end

def fixture_path(*path)
  File.join SPEC_ROOT, 'fixtures', path
end

def read_raw_fixture(*path)
  File.open fixture_path(*path), 'rb', &:read
end

def read_fixture(*path)
  Mail.read fixture_path(*path)
end

# Produces an array or printable ascii by default.
#
# We can assume if a, m and z and 1, 5, 0 work, then the rest
# of the letters and numbers work.
def ascii(from = 33, to = 126)
  chars = (from..to).map(&:chr)
  boring = ('b'..'l').to_a + ('n'..'o').to_a +
    ('p'..'y').to_a + ('B'..'L').to_a + ('N'..'O').to_a +
    ('P'..'Y').to_a + ('1'..'4').to_a + ('6'..'8').to_a
  chars - boring
end

# https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/string/strip.rb#L22
def strip_heredoc(string)
  indent = string.scan(/^[ \t]*(?=\S)/).min.size
  string.gsub(/^[ \t]{#{indent}}/, '')
end

# Original mockup from ActionMailer
class MockSMTP
  attr_accessor :open_timeout, :read_timeout

  def self.deliveries
    @@deliveries
  end

  def self.security
    @@security
  end

  def initialize
    @@deliveries = []
    @@security = nil
  end

  def sendmail(mail, from, to)
    @@deliveries << [mail, from, to]
    'OK'
  end

  def start(*args)
    if block_given?
      return yield(self)
    else
      return self
    end
  end

  def finish
    return true
  end

  def self.clear_deliveries
    @@deliveries = []
  end

  def self.clear_security
    @@security = nil
  end

  def enable_tls(context)
    raise ArgumentError, "SMTPS and STARTTLS is exclusive" if @@security && @@security != :enable_tls
    @@security = :enable_tls
    context
  end

  def enable_starttls(context = nil)
    raise ArgumentError, "SMTPS and STARTTLS is exclusive" if @@security == :enable_tls
    @@security = :enable_starttls
    context
  end

  def enable_starttls_auto(context)
    raise ArgumentError, "SMTPS and STARTTLS is exclusive" if @@security == :enable_tls
    @@security = :enable_starttls_auto
    context
  end
end

class Net::SMTP
  def self.new(*args)
    MockSMTP.new
  end
end

class MockPopMail
  def initialize(rfc2822, number)
    @rfc2822 = rfc2822
    @number = number
    @deleted = false
  end

  def pop
    @rfc2822
  end

  def number
    @number
  end

  def to_s
    "#{number}: #{pop}"
  end

  def delete
    @deleted = true
  end

  def deleted?
    @deleted
  end
end

class MockPOP3
  @@start = false

  attr_accessor :read_timeout

  def initialize
    @@popmails = []
    20.times do |i|
      # "test00", "test01", "test02", ..., "test19"
      @@popmails << MockPopMail.new("test#{i.to_s.rjust(2, '0')}", i)
    end
  end

  def self.popmails
    @@popmails.clone
  end

  def each_mail(*args)
    @@popmails.each do |popmail|
      yield popmail
    end
  end

  def mails(*args)
    @@popmails.clone
  end

  def start(*args)
    @@start = true
    block_given? ? yield(self) : self
  end

  def enable_ssl(*args)
    true
  end

  def started?
    @@start == true
  end

  def self.started?
    @@start == true
  end

  def reset
  end

  def finish
    @@start = false
  end

  def delete_all
    @@popmails = []
  end
end

require 'net/pop'
class Net::POP3
  def self.new(*args)
    MockPOP3.new
  end
end

class MockIMAPFetchData
  attr_reader :attr, :number

  def initialize(rfc822, number, flag)
    @attr = { 'RFC822' => rfc822, 'FLAGS' => flag }
    @number = number
  end

end

class MockIMAP
  @@connection = false
  @@mailbox = nil
  @@readonly = false
  @@marked_for_deletion = []
  @@default_examples = {
    :default => (0..19).map do |i|
      MockIMAPFetchData.new("test#{i.to_s.rjust(2, '0')}", i, "DummyFlag#{i}")
    end
  }
  @@default_examples['UTF-8'] = @@default_examples[:default].slice(0, 1)

  def self.examples(charset = nil)
    @@examples.fetch(charset || :default)
  end

  def initialize
    @@examples = {
      :default => @@default_examples[:default].dup,
      'UTF-8' => @@default_examples['UTF-8'].dup
    }
  end

  def login(user, password)
    @@connection = true
  end

  def disconnect
    @@connection = false
  end

  def select(mailbox)
    @@mailbox = mailbox
    @@readonly = false
  end

  def examine(mailbox)
    select(mailbox)
    @@readonly = true
  end

  def uid_search(keys, charset = nil)
    [*(0..self.class.examples(charset).size - 1)]
  end

  def uid_fetch(set, attr)
    [self.class.examples[set]]
  end

  def uid_store(set, attr, flags)
    if attr == "+FLAGS" && flags.include?(Net::IMAP::DELETED)
      @@marked_for_deletion << set
    end
  end

  def expunge
    @@marked_for_deletion.reverse.each do |i|    # start with highest index first
      self.class.examples.delete_at(i)
    end
    @@marked_for_deletion = []
  end

  def self.mailbox; @@mailbox end    # test only
  def self.readonly?; @@readonly end # test only

  def self.disconnected?; @@connection == false end
  def      disconnected?; @@connection == false end

end

require 'net/imap'
class Net::IMAP
  def self.new(*args)
    MockIMAP.new
  end
end
