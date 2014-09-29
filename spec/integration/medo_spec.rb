require 'spec_helper'

describe 'Fetching A19 from Medo' do
  describe 'a patient' do
    before { load_fixture 'medo_patient', 'md-cdae5d100d8e0131d2623c075478eb56' }
    subject { Roqua::Healthy::A19.fetch("md-cdae5d100d8e0131d2623c075478eb56") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('RGOC') }
    it { expect(subject[:identities]).to   eq([{ident: 'md-cdae5d100d8e0131d2623c075478eb56', authority: 'epd'},
                                               {ident: 'research-id-123', authority: 'medo-research-number'}]) }
    it { expect(subject[:firstname]).to    eq('Jan') }
    it { expect(subject[:initials]).to     eq('J.') }
    it { expect(subject[:lastname]).to     eq('Fictief') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:email]).to        eq('j.fictief@roqua.nl') }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Thuisstraat 42') }
    it { expect(subject[:city]).to         eq('GRUNN') }
    it { expect(subject[:zipcode]).to      eq('1234QQ') }
    it { expect(subject[:country]).to      eq('Nederland') }
    it { expect(subject[:birthdate]).to    eq('19800525') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq('0698765432') }
  end

  describe 'authentication failure' do
    before { stub_mirth_response '', 403, '12345678901' }

    it 'raises AuthenticationFailure' do
      expect { Roqua::Healthy::A19.fetch("12345678901") }.to raise_error(Roqua::Healthy::AuthenticationFailure)
    end
  end

  describe 'a patient that does not exist' do
    before { stub_mirth_response '', 404, '12345678901' }

    it 'raises PatientNotFound' do
      expect { Roqua::Healthy::A19.fetch("12345678901") }.to raise_error(Roqua::Healthy::PatientNotFound)
    end
  end
end
