module Mail
  # The TestMailer is a bare bones mailer that does nothing.  It is useful
  # when you are testing.
  # 
  # It also provides a template of the minimum methods you require to implement
  # if you want to make a custom mailer for Mail
  class TestMailer

    def initialize(values)
      @settings = {}
    end
    
    attr_accessor :settings

    def deliver!(mail)
    end
    
  end
end