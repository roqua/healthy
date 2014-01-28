module Roqua
  module Healthy
    class Client
      attr_accessor :a19_endpoint

      def initialize(options = {})
        @a19_endpoint = options[:a19_endpoint]
      end

      def a19_endpoint
        @a19_endpoint || Roqua::Healthy.a19_endpoint
      end

      def fetch_a19(patient_id)
        A19.fetch(patient_id, self)
      end
    end
  end
end

require_relative 'a19'
