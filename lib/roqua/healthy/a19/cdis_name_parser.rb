# frozen_string_literal: true
require 'roqua/healthy/a19/name_parser'

module Roqua
  module Healthy
    module A19
      # The CDIS EPD returns names in a format different from most other EPD vendors.
      # This parser overrides some methods that are affected by the differences.
      class CdisNameParser < NameParser
        def firstname
          names[:legal].fetch('PID.5.2')
        end

        def initials
          names[:legal].fetch('PID.5.3')
        end

        def lastname
          names[:legal].fetch('PID.5.1').fetch('PID.5.1.1')
        end

        def nickname
          return unless names[:nick]
          names[:nick].fetch('PID.5.2')
        end
      end
    end
  end
end
