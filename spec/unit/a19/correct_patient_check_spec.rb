require 'spec_helper'

module Roqua
  module Healthy
    module A19
      describe CorrectPatientCheck do
        let(:id)     { "12345678" }
        let(:record) { {identities: [{ident: '12345678'}]} }

        it 'returns true if record is for correct patient id' do
          checker = CorrectPatientCheck.new(id, record)
          expect(checker.check).to be_truthy
        end

        it 'returns false if record is for different patient id' do
          checker = CorrectPatientCheck.new('999', record)
          expect(checker.check).to be_falsey
        end

        let(:medoq_record) { {medoq_data: {epd_id: '12345678'}} }
        it 'also works for epd ids under medo identities' do
          checker = CorrectPatientCheck.new(id, medoq_record)
          expect(checker.check).to be_truthy
        end
      end
    end
  end
end
