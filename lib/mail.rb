module Mail
  
  raise "Requires Ruby 1.9.1 or higher, try TMail" unless RUBY_VERSION >= '1.9.1'
  
  require 'treetop'
  
  dir_name = File.join(File.dirname(__FILE__), 'mail')

  Treetop.load(File.join(dir_name, 'parsers', 'obsolete'))
  Treetop.load(File.join(dir_name, 'parsers', 'common'))
  Treetop.load(File.join(dir_name, 'parsers', 'address_list'))
  Treetop.load(File.join(dir_name, 'parsers', 'mailbox_list'))

  require File.join(dir_name, 'core_extensions')
  require File.join(dir_name, 'patterns')
  require File.join(dir_name, 'utilities')

  require File.join(dir_name, 'message')
  require File.join(dir_name, 'header')
  require File.join(dir_name, 'body')
  require File.join(dir_name, 'field')
  require File.join(dir_name, 'fields', 'structured_field')
  require File.join(dir_name, 'fields', 'unstructured_field')

  # Load in all header field types
  field_types = Dir.glob(File.join(dir_name, 'fields', '*.rb'))
  field_types.each do |field|
    require field
  end

  def Mail.message(*args, &block)
    if block_given?
      Mail::Message.new(args, &block)
    else
      Mail::Message.new(args)
    end
  end

end
