module Roqua
  module Healthy
    class Client
      include ::Roqua::Support::Instrumentation

      attr_accessor :a19_endpoint

      def initialize(options = {})
        @a19_endpoint = options[:a19_endpoint]
      end

      def a19_endpoint
        @a19_endpoint || Roqua::Healthy.a19_endpoint
      end

      def fetch_a19(patient_id)
        with_instrumentation 'hl7.a19', patient_id: patient_id do
          message = A19::Fetcher.new(patient_id, self).fetch
          patient = A19::Transformer.new(message).to_patient
          patient
        end
      end
    end
  end
end

require_relative 'a19'
