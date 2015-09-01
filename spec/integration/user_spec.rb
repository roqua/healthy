require 'spec_helper'

describe 'Fetching A19 from USER' do
  describe 'a patient' do
    before { load_fixture 'user_patient', '111111' }
    subject { Roqua::Healthy::A19.fetch("111111") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('IMPULSE') }
    it { expect(subject[:identities]).to   eq([{ident: "111111", authority: "PI"}, {ident: "111111", authority: "NNNLD"}]) }
    it { expect(subject[:firstname]).to    eq('Eerste') }
    it { expect(subject[:initials]).to     eq('E. T.') }
    it { expect(subject[:lastname]).to     eq('de Achternaam') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('L') }
    it { expect(subject[:street]).to       eq('Van Straatstraat 8') }
    it { expect(subject[:city]).to         eq('GRONINGEN') }
    it { expect(subject[:zipcode]).to      eq('9711 XX') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('19511101') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   eq(nil) }
  end

  describe 'a patient with a maiden name' do
    before { load_fixture 'user_patient_with_maiden_name', '111115' }
    subject { Roqua::Healthy::A19.fetch("111115") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('IMPULSE') }
    it { expect(subject[:identities]).to   eq([{ident: "111115", authority: "PI"}, {ident: "111111112", authority: "NNNLD"}]) }
    it { expect(subject[:firstname]).to    eq(nil) }
    it { expect(subject[:initials]).to     eq('D.') }
    it { expect(subject[:lastname]).to     eq('Meisjesnaam-Getrouwdenaam') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('L') }
    it { expect(subject[:street]).to       eq('Wegweg 2') }
    it { expect(subject[:city]).to         eq('\'T DORP') }
    it { expect(subject[:zipcode]).to      eq('8999 FF') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('19200101') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   be_nil }
  end

  describe 'a patient with gsm number and email address' do
    before { load_fixture 'user_patient_with_gsm_and_email', '111111' }
    subject { Roqua::Healthy::A19.fetch("111111") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('IMPULSE') }
    it { expect(subject[:identities]).to   eq([{ident: "111111", authority: "PI"}, {ident: "1111111", authority: "NNNLD"}]) }
    it { expect(subject[:firstname]).to    eq('Voornaam') }
    it { expect(subject[:initials]).to     eq('V. R.S.') }
    it { expect(subject[:lastname]).to     eq("Achternaam") }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        eq('test@roqua.nl') }
    it { expect(subject[:address_type]).to eq('L') }
    it { expect(subject[:street]).to       eq('Straatstraat 9') }
    it { expect(subject[:city]).to         eq('LELYSTAD') }
    it { expect(subject[:zipcode]).to      eq('8111 FF') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('19800101') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq('0611223344') }
  end

  describe 'a patient that does not exist' do
    before { load_fixture 'user_patient_not_found', '123456' }

    it 'raises PatientNotFound' do
      expect { Roqua::Healthy::A19.fetch("123456") }.to raise_error(Roqua::Healthy::PatientNotFound)
    end
  end
end
