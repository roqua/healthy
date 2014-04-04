module Roqua
  module Healthy
    module A19
      class AddressParser
        attr_reader :message

        def initialize(message)
          @message = message
        end

        def address_type
          return nil unless record
          record.fetch('PID.11.7')
        end

        def street
          return nil if record.blank? || record.fetch('PID.11.1').blank?
          record.fetch('PID.11.1').fetch('PID.11.1.1')
        end

        def city
          return nil unless record
          record.fetch('PID.11.3')
        end

        def zipcode
          return nil unless record
          record.fetch('PID.11.5')
        end

        def country
          return nil unless record
          record.fetch('PID.11.6')
        end

        def record
          @record = nil
          @record ||= message.fetch('PID').fetch('PID.11').find { |record| record.fetch('PID.11.7', :unknown_type_of_address_record) == 'M' }
          @record ||= message.fetch('PID').fetch('PID.11').find { |record| record.fetch('PID.11.7', :unknown_type_of_address_record) == 'H' }
          @record ||= message.fetch('PID').fetch('PID.11').find { |record| record.fetch('PID.11.7', :unknown_type_of_address_record) == 'L' }
          @record
        end
      end
    end
  end
end