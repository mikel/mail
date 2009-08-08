# encoding: utf-8
unless defined?(MAIL_ROOT)
  STDERR.puts("Running Specs under Ruby Version #{RUBY_VERSION}")

  MAIL_ROOT = File.join(File.dirname(__FILE__), '../')
end
require 'rubygems'
require 'ruby-debug' if RUBY_VERSION < '1.9'
require 'spec'
require 'treetop'

$:.unshift "#{File.dirname(__FILE__)}/mail"
$:.unshift "#{File.dirname(__FILE__)}/../lib"
$:.unshift "#{File.dirname(__FILE__)}/../lib/mail"

require File.join(File.dirname(__FILE__), 'matchers', 'break_down_to')

require 'mail'

Spec::Runner.configure do |config|  
  config.include(CustomMatchers)  
end

def fixture(name)
  File.join(File.dirname(__FILE__), 'fixtures', name)
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
  
  def enable_starttls
    true
  end
end
class Net::SMTP
  def self.new(*args)
    MockSMTP.new
  end
end

