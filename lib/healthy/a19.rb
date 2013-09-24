require 'net/http'
require 'active_support/core_ext/hash/conversions'

module Healthy
  class A19
    attr_reader :patient_id

    def initialize(patient_id)
      @patient_id = patient_id
    end

    def fetch
      response = mirth_response
      ensure_valid_response(response)

      data = parse_response(response.body)
      data = clean_identities(data)

      ensure_response_for_patient_id(data)
      data
    end

    private

    def ensure_valid_response(response)
      return true if response.code == '200'
      raise "Request not successful for patient #{patient_id}. Got: #{response.code}"
    end

    def parse_response(body)
      data = Hash.from_xml(body).fetch("patient") { Hash.new }

      # If we got back only one identity, from_xml turned this into a straight
      # hash, instead of an array of hashes. This works around that issue.
      data["identities"] = [data["identities"]] if data["identities"] and data["identities"].is_a?(Hash)

      data
    rescue REXML::ParseException => e
      raise IllegalMirthResponse if e.message =~ /Illegal character '&' in raw string/
    end

    def clean_identities(body)
      identities = body.fetch("identities") { Array.new }
      identities = identities.reject {|i| empty_identity?(i) }
      body.merge("identities" => identities)
    end

    def empty_identity?(identity)
      identity["ident"].blank? || identity["ident"] == "\"\""
    end

    def ensure_response_for_patient_id(body)
      return unless body["identities"].present?

      if not body["identities"].find{|i| i["ident"] == patient_id }
        raise PatientIdNotInRemote, "Patient ID not in remote details"
      end
      body
    end

    def mirth_response
      params = {'method' => 'A19',
                'patient_id' => patient_id.to_s}
      use_ssl = (remote_url.port == 443 or remote_url.scheme == 'https')

      Net::HTTP.start(remote_url.host, remote_url.port, use_ssl: use_ssl) do |http|
        request = Net::HTTP::Post.new(remote_url.path)
        request.set_form_data(params)
        http.request request
      end
    rescue ::Timeout::Error => e
      raise ::Healthy::Timeout
    rescue Errno::ETIMEDOUT => e
      raise ::Healthy::Timeout
    rescue Errno::EHOSTUNREACH => e
      raise ::Healthy::HostUnreachable
    rescue Errno::ECONNREFUSED => e
      raise ::Healthy::ConnectionRefused
    end

    def remote_url
      return @remote_url if @remote_url

      url = Addressable::URI.parse(Healthy.a19_endpoint)
      url.path = "/"

      @remote_url = URI.parse(url.to_s)
    end
  end
end