module Healthy
  module A19
    def self.fetch(patient_id)
      Fetcher.new(patient_id).fetch
    end
  end
end

require_relative 'a19/fetcher'