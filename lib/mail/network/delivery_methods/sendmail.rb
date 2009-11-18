module Mail
  class Sendmail
    include Singleton

    def settings(&block)
      if block_given?
        instance_eval(&block)
      end
      self
    end

    def path(value = nil)
      value ? @path = value : @path
    end

    def Sendmail.deliver!(mail)
      IO.popen("#{Mail.defaults.sendmail.path} #{mail.destinations.join(" ")}", "w+") do |io|
        io.puts mail.to_s
      end
    end
  end
end
