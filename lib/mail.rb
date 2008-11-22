module Mail
  require 'mail/message'
  require 'mail/core_extensions'
  
  def Mail.message(args = {}, &block)
    Mail::Message.new(args, &block)
  end

end
