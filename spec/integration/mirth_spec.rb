require 'spec_helper'

describe 'Accounting for Mirth bugs' do
  describe 'when the wrong patient is returned' do
    # Mirth has an awful bug where it will sometimes return responses out of sync
    # with the actual requests. Mirth support has been entirely unhelpful in
    # working with us to resolve this bug. Hence the need to at least stop the
    # badness on this level, make sure we don't pollute our caches with patient
    # details that don't belong to the patient we requested.

    before { load_fixture 'cdis_jan_fictief', '12345678' }

    it 'raises an error' do
      expect { Roqua::Healthy::A19.fetch("12345678") }.to raise_error(Roqua::Healthy::MirthErrors::WrongPatient)
    end
  end
end
