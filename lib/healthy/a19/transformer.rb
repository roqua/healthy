module Healthy
  module A19
    class Transformer
      attr_reader :message

      def initialize(message)
        @message = message
        @message['PID']['PID.5'] = [@message.fetch('PID').fetch('PID.5')].flatten
        @message['PID']['PID.11'] = [@message.fetch('PID').fetch('PID.11')].flatten.compact
        @message['PID']['PID.13'] = [@message.fetch('PID').fetch('PID.13')].flatten.compact
      end

      def to_patient
        patient = {}
        %w(status source identities birthdate gender
           firstname initials lastname display_name email
           address_type street city zipcode country).map(&:to_sym).each do |key|
          patient[key] = send(key)
        end
        patient
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

      def address_type
        address[:address_type]
      end

      def street
        address[:street]
      end

      def city
        address[:city]
      end

      def zipcode
        address[:zipcode]
      end

      def country
        address[:country]
      end

      private

      def names
        names = {}
        message.fetch('PID').fetch('PID.5').each do |record|
          case record.fetch('PID.5.7')
          when 'L'
            names[:legal] = record
          when 'D'
            names[:display] = record
          when 'N'
            names[:nick] = record
          else
            # ignore record
          end
        end
        names
      end

      def address
        address = {}

        message.fetch('PID').fetch('PID.11').each do |record|
          # HOME ADDRESS
          if record.fetch('PID.11.7', :unknown_type_of_address_record) == 'H'
            address[:address_type] = clean(record.fetch('PID.11.7'))
            address[:street]       = clean(record.fetch('PID.11.1').fetch('PID.11.1.1'))
            address[:city]         = clean(record.fetch('PID.11.3'))
            address[:zipcode]      = clean(record.fetch('PID.11.5'))
            address[:country]      = clean(record.fetch('PID.11.6'))
          end
        end

        message.fetch('PID').fetch('PID.11').each do |record|
          # MAILING ADDRESS
          if record.fetch('PID.11.7', :unknown_type_of_address_record) == 'M'
            address[:address_type] = clean(record.fetch('PID.11.7'))
            address[:street]       = clean(record.fetch('PID.11.1').fetch('PID.11.1.1'))
            address[:city]         = clean(record.fetch('PID.11.3'))
            address[:zipcode]      = clean(record.fetch('PID.11.5'))
            address[:country]      = clean(record.fetch('PID.11.6'))
          end
        end

        address
      end


      def clean(string)
        string.gsub(/^""$/, "")
      end
    end
  end
end
