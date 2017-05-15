# frozen_string_literal: true
require 'mail/check_delivery_params'

module Mail
  # A delivery method implementation which sends via sendmail.
  #
  # To use this, first find out where the sendmail binary is on your computer,
  # if you are on a mac or unix box, it is usually in /usr/sbin/sendmail, this will
  # be your sendmail location.
  #
  #   Mail.defaults do
  #     delivery_method :sendmail
  #   end
  #
  # Or if your sendmail binary is not at '/usr/sbin/sendmail'
  #
  #   Mail.defaults do
  #     delivery_method :sendmail, :location => '/absolute/path/to/your/sendmail'
  #   end
  #
  # Then just deliver the email as normal:
  #
  #   Mail.deliver do
  #     to 'mikel@test.lindsaar.net'
  #     from 'ada@test.lindsaar.net'
  #     subject 'testing sendmail'
  #     body 'testing sendmail'
  #   end
  #
  # Or by calling deliver on a Mail message
  #
  #   mail = Mail.new do
  #     to 'mikel@test.lindsaar.net'
  #     from 'ada@test.lindsaar.net'
  #     subject 'testing sendmail'
  #     body 'testing sendmail'
  #   end
  #
  #   mail.deliver!
  class Sendmail
    attr_accessor :settings

    class DeliveryError < StandardError
    end

    def initialize(values)

      arguments = "-i"

      if values[:use_args]
        arguments = ["-i"]
      end

      self.settings = { :location       => '/usr/sbin/sendmail',
                        :arguments      => arguments,
                        :use_args => false }.merge(values)

    end

    def deliver!(mail)
      smtp_from, smtp_to, message = Mail::CheckDeliveryParams.check(mail)

      if self.settings[:use_args]

        if RUBY_VERSION < '1.9.0'
          raise ArgumentError.new(":use_args not supported by ruby version")
        end

        exec_array = [settings[:location]]
        exec_array.concat(settings[:arguments])
        exec_array << "-f"
        exec_array << smtp_from
        exec_array << "--"
        exec_array.concat(smtp_to)
        self.class.exec_call(exec_array, message)
      else
        from = "-f #{self.class.shellquote(smtp_from)}"
        to = smtp_to.map { |_to| self.class.shellquote(_to) }.join(' ')

        arguments = "#{settings[:arguments]} #{from} --"
        self.class.call(settings[:location], arguments, to, message)      
      end

    end

    def self.exec_call(exec_array, encoded_message)
      IO.popen exec_array, "w+", :err => :out do |io|
        io.puts ::Mail::Utilities.to_lf(encoded_message)
        io.flush
      end


      if $?.exitstatus != 0
        raise DeliveryError.new("Bad Exit Status: #{$?.exitstatus}")
      end
    end

    def self.call(path, arguments, destinations, encoded_message)
      popen "#{path} #{arguments} #{destinations}" do |io|
        io.puts ::Mail::Utilities.to_lf(encoded_message)
        io.flush
      end
    end

    if RUBY_VERSION < '1.9.0'
      def self.popen(command, &block)
        IO.popen "#{command} 2>&1", 'w+', &block
      end
    else
      def self.popen(command, &block)
        IO.popen command, 'w+', :err => :out, &block
      end
    end

    # The following is an adaptation of ruby 1.9.2's shellwords.rb file,
    # it is modified to include '+' in the allowed list to allow for
    # sendmail to accept email addresses as the sender with a + in them.
    def self.shellquote(address)
      # Process as a single byte sequence because not all shell
      # implementations are multibyte aware.
      #
      # A LF cannot be escaped with a backslash because a backslash + LF
      # combo is regarded as line continuation and simply ignored. Strip it.
      escaped = address.gsub(/([^A-Za-z0-9_\s\+\-.,:\/@])/n, "\\\\\\1").gsub("\n", '')
      %("#{escaped}")
    end
  end
end
