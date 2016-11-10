# frozen_string_literal: true
module Roqua
  module Healthy
    module A19
      class NameParser
        attr_reader :message

        def initialize(message)
          @message = message
        end

        def firstname
          return unless names[:nick]
          names[:nick].fetch('PID.5.2')
        end

        def initials
          "#{names[:legal].fetch('PID.5.2')} #{names[:legal].fetch('PID.5.3')}".strip
        end

        def lastname
          prefix   = names[:legal].fetch('PID.5.1').fetch('PID.5.1.2')
          lastname = names[:legal].fetch('PID.5.1').fetch('PID.5.1.3')
          "#{prefix} #{lastname}".strip
        end

        def display_name
          return unless names[:display]
          names[:display].fetch('PID.5.1')
        end

        def nickname
          firstname
        end

        private

        def names
          names = {}
          message.fetch('PID').fetch('PID.5').each do |record|
            case record.fetch('PID.5.7', :unknown_type_of_name_record)
            when 'L'
              names[:legal] = record
            when 'D'
              names[:display] = record
            when 'N'
              names[:nick] = record
              # else ignore record
            end
          end
          names
        end
      end
    end
  end
end
