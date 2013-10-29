module Healthy
  module A19
    class CorrectPatientCheck
      attr_reader :patient_id, :record

      def initialize(patient_id, record)
        @patient_id = patient_id
        @record     = record
      end

      def check
        record[:identities].any? { |i| i[:ident] == patient_id }
      end
    end
  end
end