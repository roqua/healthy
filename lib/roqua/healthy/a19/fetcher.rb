require 'net/http'
require 'addressable/uri'

require 'roqua/healthy/a19/response_validator'
require 'roqua/healthy/a19/response_parser'

module Roqua
  module Healthy
    module A19
      class Fetcher
        attr_reader :patient_id

        def initialize(patient_id)
          @patient_id = patient_id
        end

        def fetch
          response = mirth_response
          parser   = ResponseParser.new(response)

          if ResponseValidator.new(response.code, parser, patient_id).validate
            parser.fetch("HL7Message")
          end
        end

        def mirth_response
          Net::HTTP.start(remote_url.host, remote_url.port, use_ssl: use_ssl?) do |http|
            request = Net::HTTP::Post.new(remote_url.path)
            request.set_form_data(mirth_params)
            http.request request
          end
        rescue ::Timeout::Error, Errno::ETIMEDOUT => error
          raise ::Roqua::Healthy::Timeout, error.message
        rescue Errno::EHOSTUNREACH => error
          raise ::Roqua::Healthy::HostUnreachable, error.message
        rescue Errno::ECONNREFUSED => error
          raise ::Roqua::Healthy::ConnectionRefused, error.message
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
end