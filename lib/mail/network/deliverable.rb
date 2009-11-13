# encoding: utf-8
module Mail
  # The deliverable class provides the way mail will send an email out when you
  # are using the Mail.deliver! &block command or when you call Mail.deliver!(message)
  # 
  # The default delivery is SMTP, localhost, port 25.  You can change this through the
  # Mail.defaults call.s
  module Deliverable

    def self.perform_delivery!(mail)
      Mail.defaults.delivery_method.deliver!(mail)
    end

  end
end
