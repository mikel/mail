module Mail
  # == Sending Email with Override Recipient SMTP
  #
  # Use the OverrideRecipientSMTP delivery method when you don't want your program
  # to accidentally send emails to addresses other than the overridden recipient
  # which you configure.
  #
  # An example use case is in your web app's staging environment, your development
  # team will receive all staging emails without accidentally emailing users with
  # active email addresses in the database.
  #
  # === Sending via OverrideRecipientSMTP
  #
  #   Mail.defaults do
  #     delivery_method :override_recipient_smtp, :to => 'staging@example.com'
  #   end
  #
  # === Sending to multiple email addresses
  #
  #   Mail.defaults do
  #     delivery_method :override_recipient_smtp,
  #       :to => ['dan@example.com', 'harlow@example.com']
  #   end
  #
  # === Debug
  #
  # The original to, cc, and bcc fields are stored in these custom email headers
  # for debugging:
  #
  #   X-Override-To
  #   X-Override-Cc
  #   X-Override-Bcc
  #
  class OverrideRecipientSMTP < Mail::SMTP
    def initialize(values)
      unless values[:to]
        raise ArgumentError.new('A :to option is required when using :override_recipient_smtp')
      end

      super(values)
    end

    def deliver!(mail)
      store_in_custom_headers(mail)

      mail.to = settings[:to]
      mail.cc = nil
      mail.bcc = nil

      super(mail)
    end

    private

    def store_in_custom_headers(mail)
      {
        'X-Override-To' => mail.to,
        'X-Override-Cc' => mail.cc,
        'X-Override-Bcc' => mail.bcc
      }.each do |header, addresses|
        if addresses
          addresses.each do |address|
            mail.header = "#{mail.header}\n#{header}: #{address}"
          end
        end
      end
    end
  end
end
