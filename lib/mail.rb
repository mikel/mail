# encoding: utf-8
module Mail # :doc:

  require 'date'
  
  gem "treetop", ">= 1.4"
  require 'treetop'
  gem 'activesupport', ">= 2.3"
  require 'activesupport'
  require 'uri'
  require 'net/smtp'
  require 'mime/types'
  require 'tlsmail' if RUBY_VERSION <= '1.8.6'

  dir_name = File.join(File.dirname(__FILE__), 'mail')

  if RUBY_VERSION >= "1.9.1"
    require File.join(dir_name, 'version_specific', 'ruby_1_9.rb')
    RubyVer = Mail::Ruby19
  else
    require File.join(dir_name, 'version_specific', 'ruby_1_8.rb')
    RubyVer = Mail::Ruby18
  end

  require File.join(dir_name, 'version')
  require File.join(dir_name, 'core_extensions')
  require File.join(dir_name, 'patterns')
  require File.join(dir_name, 'utilities')
  require File.join(dir_name, 'configuration')
  require File.join(dir_name, 'network', 'deliverable')
  require File.join(dir_name, 'network', 'delivery_methods', 'smtp')
  require File.join(dir_name, 'network', 'delivery_methods', 'file_delivery')
  require File.join(dir_name, 'network', 'delivery_methods', 'sendmail')
  require File.join(dir_name, 'network', 'delivery_methods', 'test_mailer')
  require File.join(dir_name, 'network', 'retrievable')
  require File.join(dir_name, 'network', 'retriever_methods', 'pop3')
  require File.join(dir_name, 'network', 'retriever_methods', 'imap')

  require File.join(dir_name, 'message')
  require File.join(dir_name, 'part')
  require File.join(dir_name, 'header')
  require File.join(dir_name, 'body')
  require File.join(dir_name, 'field')
  require File.join(dir_name, 'field_list')
  require File.join(dir_name, 'attachment')

  # Load in all common header fields modules
  commons = Dir.glob(File.join(dir_name, 'fields', 'common', '*.rb'))
  commons.each do |common|
    require common
  end

  require File.join(dir_name, 'fields', 'structured_field')
  require File.join(dir_name, 'fields', 'unstructured_field')
  require File.join(dir_name, 'envelope')

  parsers = %w[ rfc2822_obsolete rfc2822 address_lists phrase_lists
                date_time received message_ids envelope_from rfc2045 
                mime_version content_type content_disposition
                content_transfer_encoding content_location ]

  parsers.each do |parser|
    begin
      # Try requiring the pre-compiled ruby version first
      require File.join(dir_name, 'parsers', parser)
    rescue LoadError
      # Otherwise, get treetop to compile and load it
      Treetop.load(File.join(dir_name, 'parsers', parser))
    end
  end
  
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
  
  # Load in all transfer encodings
  elems = Dir.glob(File.join(dir_name, 'encodings', '*.rb'))
  elems.each do |elem|
    require elem
  end
  
  # Finally... require all the Mail.methods
  require File.join(dir_name, 'mail')

end
