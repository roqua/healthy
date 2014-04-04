require 'spec_helper'

describe 'Fetching A19 from UCP' do
  describe 'a patient' do
    before { load_fixture 'ucp_missing_address', '1234' }
    subject { Roqua::Healthy::A19.fetch('1234') }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('UMCG') }
    it { expect(subject[:identities]).to   eq([{:ident=>"1234", :authority=>"PI"}]) }
    it { expect(subject[:firstname]).to    eq('T.') }
    it { expect(subject[:initials]).to     eq('T.') }
    it { expect(subject[:lastname]).to     eq('Test') }
    it { expect(subject[:display_name]).to eq(nil) }
    it { expect(subject[:email]).to        eq(nil) }
    it { expect(subject[:address_type]).to eq('M') }
    it { expect(subject[:street]).to       eq(nil) }
    it { expect(subject[:city]).to         eq(nil) }
    it { expect(subject[:zipcode]).to      eq(nil) }
    it { expect(subject[:country]).to      eq('') }
    it { expect(subject[:birthdate]).to    eq('19900101') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq(nil) }

  end
end

