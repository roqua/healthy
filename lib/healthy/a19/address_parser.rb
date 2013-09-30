module Healthy
  module A19
    class AddressParser
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def [](key)
        address[key]
      end

      def address
        address = {}
        address[:address_type] = clean(record.fetch('PID.11.7'))
        address[:street]       = clean(record.fetch('PID.11.1').fetch('PID.11.1.1'))
        address[:city]         = clean(record.fetch('PID.11.3'))
        address[:zipcode]      = clean(record.fetch('PID.11.5'))
        address[:country]      = clean(record.fetch('PID.11.6'))
        address
      end

      def record
        @record = nil
        @record ||= message.fetch('PID').fetch('PID.11').find {|record| record.fetch('PID.11.7', :unknown_type_of_address_record) == 'M' }
        @record ||= message.fetch('PID').fetch('PID.11').find {|record| record.fetch('PID.11.7', :unknown_type_of_address_record) == 'H' }
        @record
      end

      def clean(string)
        string.gsub(/^""$/, "")
      end
    end
  end
end