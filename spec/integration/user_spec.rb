require 'spec_helper'

describe 'Fetching A19 from USER' do
  describe 'a patient' do
    before { load_fixture 'user_patient', '00000123' }
    subject { Roqua::Healthy::A19.fetch("00000123") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('IMPULSE') }
    it { expect(subject[:identities]).to   eq([{ident: '000123', authority: 'PI'}]) }
    it { expect(subject[:firstname]).to    eq('Alice') }
    it { expect(subject[:initials]).to     eq('A.B.') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('L') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234 AB') }
    it { expect(subject[:country]).to      eq('6030') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   be_nil }
  end

  describe 'a patient' do
    before { load_fixture 'user_patient_with_maiden_name', '00000123' }
    subject { Roqua::Healthy::A19.fetch("00000123") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('IMPULSE') }
    it { expect(subject[:identities]).to   eq([{ident: '00000123', authority: 'PI'}]) }
    it { expect(subject[:firstname]).to    eq('Babette') }
    it { expect(subject[:initials]).to     eq('A.B.C.') }
    it { expect(subject[:lastname]).to     eq('Achternaam') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('L') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234 AB') }
    it { expect(subject[:country]).to      eq('6030') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   be_nil }
  end

  describe 'a patient with gsm number and email address' do
    before { load_fixture 'user_patient_with_gsm_and_email', '00000033' }
    subject { Roqua::Healthy::A19.fetch("00000033") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('IMPULSE') }
    it { expect(subject[:identities]).to   eq([{ident: '00000033', authority: 'PI'}]) }
    it { expect(subject[:firstname]).to    eq('Albert') }
    it { expect(subject[:initials]).to     eq('A.') }
    it { expect(subject[:lastname]).to     eq("Pati\u00EBnt") }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        eq('apatient@info.nl') }
    it { expect(subject[:address_type]).to eq('L') }
    it { expect(subject[:street]).to       eq('Straatnaam 37') }
    it { expect(subject[:city]).to         eq('PLAATSNAAM') }
    it { expect(subject[:zipcode]).to      eq('1234 AB') }
    it { expect(subject[:country]).to      eq('6030') }
    it { expect(subject[:birthdate]).to    eq('17070415') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq('0611223344') }
  end
end