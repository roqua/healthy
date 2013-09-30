require 'healthy/a19/name_parser'
require 'healthy/a19/address_parser'

module Healthy
  module A19
    class Transformer
      attr_reader :message

      def initialize(message)
        @message = message
        @message['PID']['PID.5']  = [@message.fetch('PID').fetch('PID.5')].flatten.compact
        @message['PID']['PID.11'] = [@message.fetch('PID').fetch('PID.11')].flatten.compact
        @message['PID']['PID.13'] = [@message.fetch('PID').fetch('PID.13')].flatten.compact
      end

      def to_patient
        {
          status:       status,
          source:       source,
          identities:   identities,
          firstname:    firstname,
          initials:     initials,
          lastname:     lastname,
          display_name: display_name,
          email:        email,
          address_type: address.address_type,
          street:       address.street,
          city:         address.city,
          zipcode:      address.zipcode,
          country:      address.country,
          birthdate:    birthdate,
          gender:       gender
        }
      end

      def status
        'SUCCESS'
      end

      def source
        message.fetch('MSH').fetch('MSH.4').fetch('MSH.4.1')
      end

      def identities
        message.fetch('PID').fetch('PID.3').map do |identity|
          next if identity.fetch('PID.3.1') == "\"\""
          {ident: identity.fetch('PID.3.1'), authority: identity.fetch('PID.3.5')}
        end.compact
      end

      def firstname
        if source == "UMCG"
          names[:legal].fetch('PID.5.2')
        else
          return unless names[:nick]
          names[:nick].fetch('PID.5.2')
        end
      end

      def initials
        if source == "UMCG"
          names[:legal].fetch('PID.5.3')
        else
          "#{names[:legal].fetch('PID.5.2')} #{names[:legal].fetch('PID.5.3')}".strip
        end
      end

      def lastname
        if source == "UMCG"
          names[:legal].fetch('PID.5.1').fetch('PID.5.1.3')
        else
          prefix   = clean(names[:legal].fetch('PID.5.1').fetch('PID.5.1.2'))
          lastname = clean(names[:legal].fetch('PID.5.1').fetch('PID.5.1.3'))
          "#{prefix} #{lastname}".strip
        end
      end

      def display_name
        return unless names[:display]
        names[:display].fetch('PID.5.1')
      end

      def birthdate
        message.fetch('PID').fetch('PID.7').fetch('PID.7.1')
      end

      def email
        email_record = message.fetch('PID').fetch('PID.13').find do |record|
          record.fetch('PID.13.2', :unknown_type_of_phone_record) == 'NET'
        end
        return nil unless email_record
        clean(email_record.fetch('PID.13.1'))
      end

      def gender
        message.fetch('PID').fetch('PID.8').fetch('PID.8.1')
      end

      private

      def names
        NameParser.new(message).names
      end

      def address
        AddressParser.new(message)
      end

      def clean(string)
        string.gsub(/^""$/, "")
      end
    end
  end
end
