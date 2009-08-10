# encoding: utf-8
module Mail

  require 'treetop'
  require 'net/smtp'
  require 'net/pop'
  require 'tlsmail' if RUBY_VERSION <= '1.8.6'

  dir_name = File.join(File.dirname(__FILE__), 'mail')

  require File.join(dir_name, 'core_extensions')
  require File.join(dir_name, 'patterns')
  require File.join(dir_name, 'utilities')
  require File.join(dir_name, 'configuration')
  require File.join(dir_name, 'network', 'sendable')
  require File.join(dir_name, 'network', 'retrieve_via_pop3')

  require File.join(dir_name, 'message')
  require File.join(dir_name, 'header')
  require File.join(dir_name, 'body')
  require File.join(dir_name, 'field')
  require File.join(dir_name, 'field_list')

  # Load in all common header fields modules
  commons = Dir.glob(File.join(dir_name, 'fields', 'common', '*.rb'))
  commons.each do |common|
    require common
  end

  require File.join(dir_name, 'fields', 'structured_field')
  require File.join(dir_name, 'fields', 'unstructured_field')
  require File.join(dir_name, 'envelope')

  Treetop.load(File.join(dir_name, 'parsers', 'rfc2822_obsolete'))
  Treetop.load(File.join(dir_name, 'parsers', 'rfc2822'))
  Treetop.load(File.join(dir_name, 'parsers', 'address_lists'))
  Treetop.load(File.join(dir_name, 'parsers', 'phrase_lists'))
  Treetop.load(File.join(dir_name, 'parsers', 'date_time'))
  Treetop.load(File.join(dir_name, 'parsers', 'received'))
  Treetop.load(File.join(dir_name, 'parsers', 'message_ids'))
  Treetop.load(File.join(dir_name, 'parsers', 'envelope_from'))

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
  def Mail.deliver(*args, &block)
    Mail.message(args, &block).deliver
  end

  def Mail.get_all_mail(&block)
    Message::get_all_mail(&block)
  end

end
