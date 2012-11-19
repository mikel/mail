# encoding: utf-8
require File.expand_path('../environment', __FILE__)

unless defined?(MAIL_ROOT)
  STDERR.puts("Running Specs under Ruby Version #{RUBY_VERSION}")
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

STDERR.puts("Running Specs for Mail Version #{Mail::VERSION::STRING}")

RSpec.configure do |c|
  c.mock_with :rspec
  c.include(CustomMatchers)
end

# NOTE: We set the KCODE manually here in 1.8.X because upgrading to rspec-2.8.0 caused it
#       to default to "NONE" (Why!?).
$KCODE='UTF8' if RUBY_VERSION < '1.9'

def fixture(*name)
  File.join(SPEC_ROOT, 'fixtures', name)
end

alias doing lambda

# Produces an array or printable ascii by default.
#
# We can assume if a, m and z and 1, 5, 0 work, then the rest
# of the letters and numbers work.
def ascii(from = 33, to = 126)
  chars = []
  from.upto(to) { |c| chars << ('' << c) }
  boring = ('b'..'l').to_a + ('n'..'o').to_a +
    ('p'..'y').to_a + ('B'..'L').to_a + ('N'..'O').to_a +
    ('P'..'Y').to_a + ('1'..'4').to_a + ('6'..'8').to_a
  chars - boring
end

# Original mockup from ActionMailer
class MockSMTP

  def self.deliveries
    @@deliveries
  end

  def initialize
    @@deliveries = []
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

  # in the standard lib: net/smtp.rb line 577
  #   a TypeError is thrown unless this arg is a
  #   kind of OpenSSL::SSL::SSLContext
  def enable_tls(context = nil)
    if context && context.kind_of?(OpenSSL::SSL::SSLContext)
      true
    elsif context
      raise TypeError,
        "wrong argument (#{context.class})! "+
        "(Expected kind of OpenSSL::SSL::SSLContext)"
    end
  end

  def enable_starttls_auto
    true
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

  def initialize(rfc822, number)
    @attr = { 'RFC822' => rfc822 }
    @number = number
  end

end

class MockIMAP
  @@connection = false
  @@mailbox = nil
  @@marked_for_deletion = []

  def self.examples
    @@examples
  end

  def initialize
    @@examples = []
    (0..19).each do |i|
      @@examples << MockIMAPFetchData.new("test#{i.to_s.rjust(2, '0')}", i)
    end
  end

  def login(user, password)
    @@connection = true
  end

  def disconnect
    @@connection = false
  end

  def select(mailbox)
    @@mailbox = mailbox
  end

  def examine(mailbox)
    select(mailbox)
  end

  def uid_search(keys, charset=nil)
    [*(0..@@examples.size - 1)]
  end

  def uid_fetch(set, attr)
    [@@examples[set]]
  end

  def uid_store(set, attr, flags)
    if attr == "+FLAGS" && flags.include?(Net::IMAP::DELETED)
      @@marked_for_deletion << set
    end
  end

  def expunge
    @@marked_for_deletion.reverse.each do |i|    # start with highest index first
      @@examples.delete_at(i)
    end
    @@marked_for_deletion = []
  end

  def self.mailbox; @@mailbox end    # test only

  def self.disconnected?; @@connection == false end
  def      disconnected?; @@connection == false end

end

require 'net/imap'
class Net::IMAP
  def self.new(*args)
    MockIMAP.new
  end
end
