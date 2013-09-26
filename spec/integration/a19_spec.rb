require 'spec_helper'

describe 'Fetching A19 from XMcare' do
  it 'returns data for records with maiden name' do
    pending
    load_fixture 'xmcare_patient_with_maiden_name'
    data = {
      status: 'SUCCESS',
      channel: 'FOO',
      error: nil,
      source: 'ZIS',
      identities: [
        {ident: '12345678901', authority: 'PI'},
        {ident: '123456789',   authority: 'NNNLD'}
      ],
      firstname: 'Babette',
      initials: 'A B',
      lastname: 'Achternaam',
      display_name: 'Meisjesnaam - Achternaam',
      email: 'email@example.com',
      address_type: nil,
      street: nil,
      city: nil,
      zipcode: nil,
      country: nil,
      birthdate: '17070415',
      gender: 'F'
    }

    Healthy::A19.fetch("123").should == data
  end
end