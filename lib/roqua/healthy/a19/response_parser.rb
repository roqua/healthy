# frozen_string_literal: true
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
          # from_xml will throw 'IOError: not modifiable string' without using dup in ActiveSupport 4.*
          @parsed_body ||= Hash.from_xml(response.body.dup)
        rescue REXML::ParseException => e
          raise IllegalMirthResponse, e.message
        end
      end
    end
  end
end
