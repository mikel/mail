module Mail
  module Parsers
    module Ragel
      module Ruby
        Mail::Parsers::Ragel::FIELD_PARSERS.each do |field_parser|
          require "mail/parsers/ragel/ruby/machines/#{field_parser}_machine"
        end

        MACHINE_LIST = {
          :address_lists => AddressListsMachine,
          :phrase_lists => PhraseListsMachine,
          :date_time => DateTimeMachine,
          :received => ReceivedMachine,
          :message_ids => MessageIdsMachine,
          :envelope_from => EnvelopeFromMachine,
          :mime_version => MimeVersionMachine,
          :content_type => ContentTypeMachine,
          :content_disposition => ContentDispositionMachine,
          :content_transfer_encoding => ContentTransferEncodingMachine,
          :content_location => ContentLocationMachine
        }

        def self.parse(machine, string)
          MACHINE_LIST[machine].parse(string)
        end
      end
    end
  end
end
