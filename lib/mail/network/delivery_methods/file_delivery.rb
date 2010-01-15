module Mail
  
  # FileDelivery class delivers emails into multiple files based on the destination
  # address.  Each file is appended to if it already exists.
  # 
  # So if you have an email going to fred@test, bob@test, joe@anothertest, and you
  # set your location path to ~/tmp/mails then FileDelivery will create ~/tmp/mails
  # if it does not exist, and put one copy of the email in three files, called
  # "fred@test", "bob@test" and "joe@anothertest"
  # 
  # Make sure the path you specify with :location is writable by the Ruby process
  # running Mail.
  class FileDelivery

    require 'ftools'

    def initialize(values)
      self.settings = { :location => './mails' }.merge!(values)
    end
    
    attr_accessor :settings
    
    def deliver!(mail)
      ::File.makedirs settings[:location]

      mail.destinations.uniq.each do |to|
        ::File.open(::File.join(settings[:location], to), 'a') { |f| "#{f.write(mail.encoded)}\r\n\r\n" }
      end
    end
    
  end
end