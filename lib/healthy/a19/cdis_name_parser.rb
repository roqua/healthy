module Healthy
  module A19
    class CdisNameParser < NameParser
      def firstname
        names[:legal].fetch('PID.5.2')
      end

      def initials
        names[:legal].fetch('PID.5.3')
      end

      def lastname
        names[:legal].fetch('PID.5.1').fetch('PID.5.1.3')
      end
    end
  end
end