require 'roqua/healthy/a19/response_parser'

module Roqua
  module Healthy
    module A19
      class ResponseValidator
        attr_reader :response_code
        attr_reader :parser
        attr_reader :patient_id

        def initialize(response_code, parser, patient_id)
          @response_code = response_code
          @parser        = parser
          @patient_id    = patient_id
        end

        def validate
          case response_code
          when '200'
            validate_200
          when '403'
            validate_403
          when '404'
            validate_404
          when '500'
            validate_500
          else
            raise ::Roqua::Healthy::UnknownFailure, "Unexpected HTTP response code #{response_code}."
          end
        end

        def validate_200
          parsed_message = parser.fetch("HL7Message")
          ensure_patient_found(parsed_message)
          ensure_correct_patient(parsed_message)
          true
        end

        def validate_403
          raise ::Roqua::Healthy::AuthenticationFailure
        end

        def validate_404
          raise ::Roqua::Healthy::PatientNotFound
        end

        def validate_500
          failure = parser.fetch("failure")
          raise ::Roqua::Healthy::Timeout, failure["error"]           if failure["error"] == "Timeout waiting for ACK"
          raise ::Roqua::Healthy::Timeout, failure["error"]           if failure["error"] == "Unable to connect to destination\tSocketTimeoutException\tconnect timed out"
          raise ::Roqua::Healthy::ConnectionRefused, failure["error"] if failure["error"] == "Unable to connect to destination\tConnectException\tConnection refused"
          raise ::Roqua::Healthy::UnknownFailure, failure["error"]
        end

        private

        def ensure_patient_found(parsed_message)
          raise ::Roqua::Healthy::PatientNotFound if parsed_message.key?("ERR") && parsed_message.fetch("ERR").fetch("ERR.1").fetch("ERR.1.4").fetch("ERR.1.4.2") =~ /Patient \(@\) niet gevonden\(.*\)/
          raise ::Roqua::Healthy::PatientNotFound if parsed_message.key?("QAK") && parsed_message.fetch("QAK").fetch("QAK.2").fetch("QAK.2.1") == "NF"
        end

        def ensure_correct_patient(parsed_message)
          raise ::Roqua::Healthy::MirthErrors::WrongPatient if parsed_message.key?('QRD') && parsed_message.fetch("QRD").fetch("QRD.8").fetch("QRD.8.1") != patient_id
        end
      end
    end
  end
end
