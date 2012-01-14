module Mail

  class Exim < Sendmail

    def deliver!(mail)
      envelope_from = mail.return_path || mail.sender || mail.from_addrs.first
      return_path = "-f \"#{envelope_from.to_s.shellescape}\"" if envelope_from
      arguments = [settings[:arguments], return_path].compact.join(" ")
      self.class.call(settings[:location], arguments, mail)
    end

    def self.call(path, arguments, mail)
      IO.popen("#{path} #{arguments}", "w+") do |io|
        io.puts mail.encoded.to_lf
        io.flush
      end
    end

  end
end
