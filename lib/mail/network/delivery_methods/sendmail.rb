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
      mail.return_path ? return_path = "-f \"#{mail.return_path}\"" : reply_to = ''
      IO.popen("#{Mail.defaults.sendmail.path} #{return_path} #{mail.destinations.join(" ")}", "w+") do |io|
        io.puts mail.to_s
        io.flush
      end
    end
  end
end
