module Mail
  
  raise "Requires Ruby 1.9.1 or higher, try TMail" unless RUBY_VERSION >= '1.9.1'
  

  require File.join(File.dirname(__FILE__), 'mail/message')
  require File.join(File.dirname(__FILE__), 'mail/core_extensions')
  
  def Mail.message(*args, &block)
    if block_given?
      Mail::Message.new(args, &block)
    else
      Mail::Message.new(args)
    end
  end

end
