# encoding: utf-8
module Mail
  
  require 'treetop'
  require 'net/smtp'
  if RUBY_VERSION <= '1.8.6'
    gem 'smtp_tls', '>= 0' # avoids loading 'smtp_tls.rb' from adzap-ar_mailer
    require 'smtp_tls'
  end

  dir_name = File.join(File.dirname(__FILE__), 'mail')

  require File.join(dir_name, 'core_extensions')
  require File.join(dir_name, 'patterns')
  require File.join(dir_name, 'utilities')

  require File.join(dir_name, 'message')
  require File.join(dir_name, 'header')
  require File.join(dir_name, 'body')
  require File.join(dir_name, 'field')
  require File.join(dir_name, 'field_list')

  require File.join(dir_name, 'configuration')

  # Load in all common header fields modules
  commons = Dir.glob(File.join(dir_name, 'fields', 'common', '*.rb'))
  commons.each do |common|
    require common
  end

  require File.join(dir_name, 'fields', 'structured_field')
  require File.join(dir_name, 'fields', 'unstructured_field')

  Treetop.load(File.join(dir_name, 'parsers', 'rfc2822_obsolete'))
  Treetop.load(File.join(dir_name, 'parsers', 'rfc2822'))
  Treetop.load(File.join(dir_name, 'parsers', 'address_lists'))
  Treetop.load(File.join(dir_name, 'parsers', 'phrase_lists'))
  Treetop.load(File.join(dir_name, 'parsers', 'date_time'))
  Treetop.load(File.join(dir_name, 'parsers', 'received'))

  # Load in all header field elements
  elems = Dir.glob(File.join(dir_name, 'elements', '*.rb'))
  elems.each do |elem|
    require elem
  end

  # Load in all header fields
  fields = Dir.glob(File.join(dir_name, 'fields', '*.rb'))
  fields.each do |field|
    require field
  end

  def Mail.message(*args, &block)
    if block_given?
      Mail::Message.new(args, &block)
    else
      Mail::Message.new(args)
    end
  end

  # Set the default configuration to send and receive emails
  #
  #   Mail.defaults do
  #     smtp 'smtp.myhost.fr', 587
  #     pop3 'pop.myhost.fr'
  #     user 'bernardo'
  #     pass 'mypass'
  #     enable_tls
  #   end
  def Mail.defaults(&block)
    if block_given?
      Mail::Configuration.instance.defaults(&block)
    end
  end

  # Send an email using the default configuration
  def Mail.send(*args, &block)
    message = Mail.message(args, &block)
    
    config = Mail::Configuration.instance
    raise ArgumentError.new('Please call +Mail.defaults+ to set the SMTP configuration') unless config.smtp
    
    smtp = Net::SMTP.new(config.smtp[0], config.smtp[1])
    if config.tls?
      smtp.enable_starttls
    else
      smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto)
    end
    
    smtp.start(helo = 'localhost.localdomain', config.user, config.pass, authentication = :plain) do |smtp|
      smtp.sendmail(message.encoded, message.from, message.to)
    end
    
    message
  end

end
