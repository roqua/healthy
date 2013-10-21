require 'active_support/core_ext/hash/conversions'

module Healthy
  module A19
    class ResponseParser
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def parse(root)
        parsed = Hash.from_xml(response.body)
        parsed.fetch(root) { Hash.new }
      rescue REXML::ParseException => e
        raise IllegalMirthResponse, e.message
      end
    end
  end
end