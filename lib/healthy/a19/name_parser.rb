module Healthy
  module A19
    class NameParser
      attr_reader :message

      def initialize(message)
        @message = message
      end

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
    end
  end
end