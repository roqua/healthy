require 'net/http'
require 'addressable/uri'

require 'healthy/a19/response_validator'
require 'healthy/a19/response_parser'

module Healthy
  module A19
    class Fetcher
      attr_reader :patient_id

      def initialize(patient_id)
        @patient_id = patient_id
      end

      def fetch
        response = mirth_response
        ResponseValidator.new(response).validate
        ResponseParser.new(response).parse("HL7Message")
      end

      def mirth_response
        Net::HTTP.start(remote_url.host, remote_url.port, use_ssl: use_ssl?) do |http|
          request = Net::HTTP::Post.new(remote_url.path)
          request.set_form_data(mirth_params)
          http.request request
        end
      rescue ::Timeout::Error, Errno::ETIMEDOUT => error
        raise ::Healthy::Timeout, error.message
      rescue Errno::EHOSTUNREACH => error
        raise ::Healthy::HostUnreachable, error.message
      rescue Errno::ECONNREFUSED => error
        raise ::Healthy::ConnectionRefused, error.message
      end

      private

      def mirth_params
        {'method' => 'A19', 'patient_id' => patient_id.to_s, 'application' => "healthy"}
      end

      def use_ssl?
        remote_url.port == 443 || remote_url.scheme == 'https'
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