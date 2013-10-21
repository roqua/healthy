require 'net/http'
require 'addressable/uri'
require 'active_support/core_ext/hash/conversions'

module Healthy
  module A19
    class Fetcher
      attr_reader :patient_id

      def initialize(patient_id)
        @patient_id = patient_id
      end

      def fetch
        response = mirth_response
        raise_unless_valid_response(response)
        parse_response(response).fetch("HL7Message") { Hash.new }
      end

      def mirth_response
        Net::HTTP.start(remote_url.host, remote_url.port, use_ssl: use_ssl?) do |http|
          request = Net::HTTP::Post.new(remote_url.path)
          request.set_form_data(mirth_params)
          http.request request
        end
      rescue ::Timeout::Error, Errno::ETIMEDOUT
        raise ::Healthy::Timeout
      rescue Errno::EHOSTUNREACH
        raise ::Healthy::HostUnreachable
      rescue Errno::ECONNREFUSED
        raise ::Healthy::ConnectionRefused
      end

      def raise_unless_valid_response(response)
        case response.code
        when '200'
          true
        when '500'
          failure = parse_response(response).fetch("failure")
          raise ::Healthy::Timeout, failure["error"] if failure["error"] == "Timeout waiting for ACK"
          raise ::Healthy::Timeout, failure["error"] if failure["error"] == "Unable to connect to destination\tSocketTimeoutException\tconnect timed out"
          raise ::Healthy::ConnectionRefused, failure["error"] if failure["error"] == "Unable to connect to destination\tConnectException\tConnection refused"
          raise ::Healthy::UnknownFailure, failure["error"]
        else
          raise "Unexpected HTTP response code #{response.code} while fetching #{patient_id}."
        end
      end

      def parse_response(response)
        Hash.from_xml(response.body)
      rescue REXML::ParseException => e
        raise IllegalMirthResponse, e.message
      end

      private

      def mirth_params
        {'method' => 'A19', 'patient_id' => patient_id.to_s, 'application' => "healthy"}
      end

      def use_ssl?
        remote_url.port == 443 or remote_url.scheme == 'https'
      end

      def remote_url
        return @remote_url if @remote_url

        url = Addressable::URI.parse(Healthy.a19_endpoint)
        url.path = "/"

        @remote_url = URI.parse(url.to_s)
      end
    end
  end
end