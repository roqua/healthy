require 'healthy/a19/response_parser'

module Healthy
  module A19
    class ResponseValidator
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def validate
        case response.code
        when '200'
          true
        when '500'
          validate_500
        else
          raise ::Healthy::UnknownFailure, "Unexpected HTTP response code #{response.code}."
        end
      end

      def validate_500
        failure = ResponseParser.new(response).parse("failure")
        raise ::Healthy::Timeout, failure["error"]           if failure["error"] == "Timeout waiting for ACK"
        raise ::Healthy::Timeout, failure["error"]           if failure["error"] == "Unable to connect to destination\tSocketTimeoutException\tconnect timed out"
        raise ::Healthy::ConnectionRefused, failure["error"] if failure["error"] == "Unable to connect to destination\tConnectException\tConnection refused"
        raise ::Healthy::UnknownFailure, failure["error"]
      end
    end
  end
end