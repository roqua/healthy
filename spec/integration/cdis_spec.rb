require 'spec_helper'

describe 'Fetching A19 from CDIS' do
  it 'returns data for basic record' do
    load_fixture 'cdis_patient', '7767853'
    data = {
      status: 'SUCCESS',
      channel: 'FOO',
      error: nil,
      source: 'UMCG',
      identities: [
        {ident: '7767853', authority: 'PI'}
      ],
      firstname: 'Jan',
      initials: 'J.A.B.C.',
      lastname: 'Fictief',
      display_name: nil,
      email: nil,
      address_type: nil,
      street: nil,
      city: nil,
      zipcode: nil,
      country: nil,
      birthdate: '19800101',
      gender: 'M'
    }

    response = Healthy::A19.fetch("7767853")
    data.each do |key, value|
      [:todo, value].should include(response[key])
    end
  end
end