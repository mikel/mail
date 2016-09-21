# frozen_string_literal: true
require 'mail/parsers/parser_info'

module Mail
  module Parsers
    module Ragel
      # Ragel-generated parsers are full of known warnings. Suppress them.
      begin
        orig, $VERBOSE = $VERBOSE, nil
        Mail::Parsers::Ragel::FIELD_PARSERS.each do |field_parser|
          require "mail/parsers/#{field_parser}_machine"
        end
      ensure
        $VERBOSE = orig
      end

      MACHINES = {
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
        MACHINES.fetch(machine).parse(string)
      end
    end
  end
end
