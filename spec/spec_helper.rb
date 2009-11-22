# encoding: utf-8

unless defined?(MAIL_ROOT)
  STDERR.puts("Running Specs under Ruby Version #{RUBY_VERSION}")
  MAIL_ROOT = File.join(File.dirname(__FILE__), '../')
end

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.join(File.dirname(__FILE__))
end

environment = File.expand_path('../../vendor/gems/environment')
if File.exist?("#{environment}.rb")
  require environment
else
  require 'rubygems'
  gem "treetop", ">= 1.4"
  gem 'activesupport', ">= 2.3"

  begin
    require 'ruby-debug' if RUBY_VERSION < '1.9'
  rescue LoadError
    # Skip debugger if unavailable.
  end
  require 'spec'
  require 'treetop'
end

require File.join(File.dirname(__FILE__), 'matchers', 'break_down_to')

require 'mail'

Spec::Runner.configure do |config|  
  config.include(CustomMatchers)  
end

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
  end

  def start(*args)
    yield self
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

  def enable_starttls
    true
  end
  
end

class Net::SMTP
  def self.new(*args)
    MockSMTP.new
  end
end

class MockPopMail
  def initialize(rfc2822)
    @rfc2822 = rfc2822
  end
  
  def pop
    Mail.new(@rfc2822)
  end
end

class MockPOP3
  @@start = false
  
  def initialize
    @@popmails = [
      MockPopMail.new('test1'),
      MockPopMail.new('test2'),
    ]
  end

  def self.popmails
    @@popmails
  end
  
  def each_mail(*args)
    @@popmails.each do |popmail|
      yield popmail
    end
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
end

class Net::POP3
  def self.new(*args)
    MockPOP3.new
  end
end
