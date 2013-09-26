module Healthy
  module A19
    def self.fetch(patient_id)
      message = Fetcher.new(patient_id).fetch
      Transformer.new(message).to_patient
    end
  end
end

require_relative 'a19/fetcher'
require_relative 'a19/transformer'