module Mail
  require 'mail/message'
  require 'mail/core_extensions'
  
  def Mail.message(*args, &block)
    if block_given?
      Mail::Message.new(args, &block)
    else
      Mail::Message.new(args)
    end
  end

end
