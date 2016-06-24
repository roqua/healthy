require 'spec_helper'

describe 'Fetching A19 from XMcare' do
  describe 'a patient' do
    before { load_fixture 'xmcare_patient', '12345678901' }
    subject { Roqua::Healthy::A19.fetch("12345678901") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('ZIS') }
    it do
      expect(subject[:identities]).to eq([{ident: '12345678901', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('Babette') }
    it { expect(subject[:initials]).to     eq('A B') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to eq('Achternaam') }
    it { expect(subject[:email]).to        eq('') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   eq('06-12345678') }
  end

  describe 'a patient with a maiden name' do
    before { load_fixture 'xmcare_patient_with_maiden_name', '12345678901' }
    subject { Roqua::Healthy::A19.fetch("12345678901") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('ZIS') }
    it do
      expect(subject[:identities]).to eq([{ident: '12345678901', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('Babette') }
    it { expect(subject[:initials]).to     eq('A B') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to eq('Meisjesnaam - Achternaam') }
    it { expect(subject[:email]).to        eq('email@example.com') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   eq('06-12345678') }
  end

  describe 'a patient without a known birthdate' do
    before { load_fixture 'xmcare_patient_without_birthdate', '12345678901' }
    subject { Roqua::Healthy::A19.fetch("12345678901") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('ZIS') }
    it do
      expect(subject[:identities]).to eq([{ident: '12345678901', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('Babette') }
    it { expect(subject[:initials]).to     eq('A B') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to eq('Achternaam') }
    it { expect(subject[:email]).to        eq('') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    be_nil }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   eq('06-12345678') }
  end

  describe 'a patient with an email in an alternate place' do
    before { load_fixture 'xmcare_patient_email_in_field_number_four', '12345678901' }
    subject { Roqua::Healthy::A19.fetch("12345678901") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('ZIS') }
    it do
      expect(subject[:identities]).to eq([{ident: '12345678901', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('Babette') }
    it { expect(subject[:initials]).to     eq('A B') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to eq('Achternaam') }
    it { expect(subject[:email]).to        eq('email@example.com') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   eq('06 12 34 56 78') }
  end

  describe 'a patient from an xmcare instance impersonating cdis' do
    before { load_fixture 'xmcare_impersonating_cdis', '12345678901' }
    subject { Roqua::Healthy::A19.fetch("12345678901") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('UMCG') }
    it do
      expect(subject[:identities]).to eq([{ident: '12345678901', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('A') }
    it { expect(subject[:initials]).to     eq('B C') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to eq('Achternaam') }
    it { expect(subject[:email]).to        eq('') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Straatnaam 37 h-42') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('NLD') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq('06-12345678') }
  end

  describe 'a patient with a cell phone number in the primary residence number field' do
    before { load_fixture 'xmcare_phone_number', '88888888888' }
    subject { Roqua::Healthy::A19.fetch("88888888888") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('XMCARE') }
    it do
      expect(subject[:identities]).to eq([{ident: '88888888888', authority: 'PI'},
                                          {ident: '222222222', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('Voorname') }
    it { expect(subject[:initials]).to     eq('V') }
    it { expect(subject[:lastname]).to     eq('Achternom') }
    it { expect(subject[:display_name]).to eq('Achternom') }
    it { expect(subject[:email]).to        eq('support@roqua.nl') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Straat 8') }
    it { expect(subject[:city]).to         eq('GRONINGEN') }
    it { expect(subject[:zipcode]).to      eq('9711CR') }
    it { expect(subject[:country]).to      eq('NED') }
    it { expect(subject[:birthdate]).to    eq('19900101') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   eq('0612345678') }
  end

  describe 'a patient that does not exist' do
    before { load_fixture 'xmcare_patient_not_found', '12345678901' }

    it 'raises PatientNotFound' do
      expect { Roqua::Healthy::A19.fetch("12345678901") }.to raise_error(Roqua::Healthy::PatientNotFound)
    end
  end
end
