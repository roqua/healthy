# frozen_string_literal: true
require 'spec_helper'

describe 'Fetching A19 from EPIC' do
  describe 'the patient Jan Fictief' do
    before { load_fixture 'epic_test_client', '7767853' }
    subject { Roqua::Healthy::A19.fetch("7767853") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('CLOVDMZA') }
    it { expect(subject[:identities]).to   eq([{ident: '7767853', authority: 'PI'}]) }
    it { expect(subject[:firstname]).to    eq('Jan') }
    it { expect(subject[:initials]).to     eq('J A B C') }
    it { expect(subject[:lastname]).to     eq('Fictief') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:nickname]).to     eq('Jan') }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('P') }
    it { expect(subject[:street]).to       eq('HANZEPLEIN 1') }
    it { expect(subject[:city]).to         eq('GRONINGEN') }
    it { expect(subject[:zipcode]).to      eq('9713GZ') }
    it { expect(subject[:country]).to      eq('NLD') }
    it { expect(subject[:birthdate]).to    eq('19800101') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq('0667895432') }
  end
end
