module Roqua
  module Healthy
    module A19
      class CorrectPatientCheck
        attr_reader :patient_id, :record

        def initialize(patient_id, record)
          @patient_id = patient_id
          @record     = record
        end

        def check
          epd_id_in_hl7_identities = record[:identities].try(:any?) { |i| i[:ident] == patient_id }
          epd_id_in_medoq_data = record[:medoq_data].try(:[], :epd_id) == patient_id
          epd_id_in_hl7_identities || epd_id_in_medoq_data
        end
      end
    end
  end
end
