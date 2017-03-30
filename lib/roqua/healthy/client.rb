# frozen_string_literal: true
module Roqua
  module Healthy
    class Client
      include ::Roqua::Support::Instrumentation

      attr_accessor :a19_endpoint
      attr_accessor :a19_username
      attr_accessor :a19_password

      def initialize(options = {})
        @a19_endpoint = options[:a19_endpoint]
        @a19_username, @a19_password = vault_data.values_at(:username, :password)
      end

      def a19_endpoint
        @a19_endpoint || Roqua::Healthy.a19_endpoint
      end

      def vault_data
        Vault.address = ENV["VAULT_ADDR"]
        Vault.token = ENV["VAULT_TOKEN"]
        Vault.with_retries(Vault::HTTPConnectionError) do
          Vault.logical.read("secret/medo/#{ENV['RAILS_ENV']}/a19_basic_auth").data
        end
      end

      def fetch_a19(patient_id)
        with_instrumentation 'hl7.a19', patient_id: patient_id do
          message = A19::Fetcher.new(patient_id, self).fetch
          patient = A19::Transformer.new(message).to_patient
          patient
        end
      end
    end
  end
end

require_relative 'a19'
