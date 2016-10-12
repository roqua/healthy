require 'spec_helper'

describe 'Fetching A19 from Comez' do
  describe 'a patient' do
    before { load_fixture 'comez_patient', '0000123456' }
    subject { Roqua::Healthy::A19.fetch("0000123456") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('CS') }
    it do
      expect(subject[:identities]).to eq([{ident: '0000123456', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('Voornaam') }
    it { expect(subject[:initials]).to     eq('A') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:nickname]).to     eq('Voornaam') }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('M') }
    it { expect(subject[:street]).to       eq('Postadresstraat 42') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('F') }
    # phone cells with letters are rejected, because it usually means they can not be used as a client's own
    # cell phone number
    it { expect(subject[:phone_cell]).to   eq(nil) }
  end
end
