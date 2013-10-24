require 'spec_helper'

module Healthy
  module A19
    describe CorrectPatientCheck do
      let(:id)     { "12345678" }
      let(:record) { {identities: [{ident: '12345678'}]} }

      it 'returns true if record is for correct patient id' do
        checker = CorrectPatientCheck.new(id, record)
        expect(checker.check).to be_true
      end

      it 'returns false if record is for different patient id' do
        checker = CorrectPatientCheck.new('999', record)
        expect(checker.check).to be_false
      end
    end
  end
end