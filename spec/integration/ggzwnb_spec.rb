# frozen_string_literal: true
require 'spec_helper'

describe 'Fetching A19 from GGZWNB' do
  describe 'a patient' do
    before { load_fixture 'ggzwnb_patient', '1234567' }
    subject { Roqua::Healthy::A19.fetch("1234567") }

    it { expect(subject[:status]).to eq('SUCCESS') }
    it { expect(subject[:error]).to  be_nil }
    it { expect(subject[:source]).to eq('UMCG') }
    it do
      expect(subject[:identities]).to eq([{ident: '1234567', authority: 'PI'},
                                          {ident: '123456789', authority: 'NNNLD'}])
    end
    it { expect(subject[:firstname]).to    eq('G') }
    it { expect(subject[:initials]).to     eq('M') }
    it { expect(subject[:lastname]).to     eq('Geit') }
    it { expect(subject[:display_name]).to eq('Geit') }
    it { expect(subject[:nickname]).to     eq('Gerda') }
    it { expect(subject[:email]).to        be_blank }
    it { expect(subject[:address_type]).to eq('H') }
    it { expect(subject[:street]).to       eq('Wegweg 1') }
    it { expect(subject[:city]).to         eq('Dorp') }
    it { expect(subject[:zipcode]).to      eq('1234AB') }
    it { expect(subject[:country]).to      eq('6030') }
    it { expect(subject[:birthdate]).to    eq('19880101') }
    it { expect(subject[:gender]).to       eq('F') }
    # phone cells with letters are rejected, because it usually means they can not be used as a client's own
    # cell phone number
    it { expect(subject[:phone_cell]).to   eq('0612345678') }
  end
end
