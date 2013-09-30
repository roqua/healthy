module Healthy
  module A19
    class AddressParser
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def address_type
        clean(record.fetch('PID.11.7'))
      end

      def street
        clean(record.fetch('PID.11.1').fetch('PID.11.1.1'))
      end

      def city
        clean(record.fetch('PID.11.3'))
      end

      def zipcode
        clean(record.fetch('PID.11.5'))
      end

      def country
        clean(record.fetch('PID.11.6'))
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