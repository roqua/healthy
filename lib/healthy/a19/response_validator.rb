require 'healthy/a19/response_parser'

module Healthy
  module A19
    class ResponseValidator
      attr_reader :response_code
      attr_reader :parser

      def initialize(response_code, parser)
        @response_code = response_code
        @parser        = parser
      end

      def validate
        case response_code
        when '200'
          validate_200
        when '500'
          validate_500
        else
          raise ::Healthy::UnknownFailure, "Unexpected HTTP response code #{response_code}."
        end
      end

      def validate_200
        failure = parser.fetch("HL7Message")
        raise ::Healthy::PatientNotFound if failure.key?("ERR") && failure.fetch("ERR").fetch("ERR.1").fetch("ERR.1.4").fetch("ERR.1.4.2") =~ /Patient \(@\) niet gevonden\(.*\)/
        true
      end

      def validate_500
        failure = parser.fetch("failure")
        raise ::Healthy::Timeout, failure["error"]           if failure["error"] == "Timeout waiting for ACK"
        raise ::Healthy::Timeout, failure["error"]           if failure["error"] == "Unable to connect to destination\tSocketTimeoutException\tconnect timed out"
        raise ::Healthy::ConnectionRefused, failure["error"] if failure["error"] == "Unable to connect to destination\tConnectException\tConnection refused"
        raise ::Healthy::UnknownFailure, failure["error"]
      end
    end
  end
end