require 'roqua/healthy/a19/name_parser'

module Roqua
  module Healthy
    module A19
      # The Impulse user epd hl7 format almost matches the xmcare one, except for maiden names-married names
      # being combined in PID 5.1.1
      class ImpulseNameParser < NameParser
        def lastname
          names[:legal].fetch('PID.5.1').fetch('PID.5.1.1')
        end
      end
    end
  end
end
