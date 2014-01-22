require 'active_support/core_ext/hash/conversions'

module Roqua
  module Healthy
    module A19
      class ResponseParser
        attr_reader :response

        def initialize(response)
          @response = response
        end

        def fetch(root)
          parsed_body[root] || {}
        end

        private

        def parsed_body
          @parsed_body ||= Hash.from_xml(response.body)
        rescue REXML::ParseException => e
          raise IllegalMirthResponse, e.message
        end
      end
    end
  end
end