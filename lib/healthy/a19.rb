module Healthy
  module A19
    extend ::Roqua::Logging

    # Fetches a patient record given a `patient_id` and returns a hash containing
    # the interesting information that was returned from an upstream `ADR^A19`
    # response.
    #
    # @param  patient_id [String] the patient identifier
    # @return [Hash] the patient details.
    def self.fetch(patient_id)
      eventlog.lifecycle('roqua.hl7.a19', patient_id: patient_id) do
        message = Fetcher.new(patient_id).fetch
        patient = Transformer.new(message).to_patient
        patient
      end
    end
  end
end

require_relative 'a19/fetcher'
require_relative 'a19/transformer'
require_relative 'a19/correct_patient_check'