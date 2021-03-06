# frozen_string_literal: true
require 'spec_helper'

describe 'Fetching A19 from CDIS' do
  describe 'the patient Jan Fictief' do
    before { load_fixture 'cdis_jan_fictief', '7767853' }
    subject { Roqua::Healthy::A19.fetch("7767853") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('UMCG') }
    it { expect(subject[:identities]).to   eq([{ident: '7767853', authority: 'PI'}]) }
    it { expect(subject[:firstname]).to    eq('Jan') }
    it { expect(subject[:initials]).to     eq('J.A.B.C.') }
    it { expect(subject[:lastname]).to     eq('Fictief') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:nickname]).to     be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('M') }
    it { expect(subject[:street]).to       eq('-Hanzepleinfout 1') }
    it { expect(subject[:city]).to         eq('Groningen') }
    it { expect(subject[:zipcode]).to      eq('42869') }
    it { expect(subject[:country]).to      eq('') }
    it { expect(subject[:birthdate]).to    eq('19800101') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   eq('0612345678') } # - stripped
  end

  describe 'the patient Piet Fictief' do
    before { load_fixture 'cdis_piet_fictief', '7718758' }
    subject { Roqua::Healthy::A19.fetch("7718758") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('UMCG') }
    it { expect(subject[:identities]).to   eq([{ident: '7718758', authority: 'PI'}]) }
    it { expect(subject[:firstname]).to    eq('Piet') }
    it { expect(subject[:initials]).to     eq('P.X.X.X.') }
    it { expect(subject[:lastname]).to     eq('Fictief') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:nickname]).to     be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('M') }
    it { expect(subject[:street]).to       eq('Ziekenhuisplein 1') }
    it { expect(subject[:city]).to         eq('Assen') }
    it { expect(subject[:zipcode]).to      eq('9402XX') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('19121212') }
    it { expect(subject[:gender]).to       eq('M') }
    it { expect(subject[:phone_cell]).to   be_nil }
  end

  describe 'the patient Gerda Geit' do
    before { load_fixture 'cdis_gerda_geit', '7078387' }
    subject { Roqua::Healthy::A19.fetch("7078387") }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('UMCG') }
    it { expect(subject[:identities]).to   eq([{ident: '7078387', authority: 'PI'}, {ident: '003704397', authority: 'NNNLD'}]) }
    it { expect(subject[:firstname]).to    eq('Gerda') }
    it { expect(subject[:initials]).to     eq('G.') }
    it { expect(subject[:lastname]).to     eq('Geit') }
    it { expect(subject[:display_name]).to be_nil }
    it { expect(subject[:nickname]).to     be_nil }
    it { expect(subject[:email]).to        be_nil }
    it { expect(subject[:address_type]).to eq('M') }
    it { expect(subject[:street]).to       eq('-Oostersnglfout') }
    it { expect(subject[:city]).to         eq('Groningen') }
    it { expect(subject[:zipcode]).to      eq('9713EZ') }
    it { expect(subject[:country]).to      eq('NL') }
    it { expect(subject[:birthdate]).to    eq('19880101') }
    it { expect(subject[:gender]).to       eq('F') }
    it { expect(subject[:phone_cell]).to   be_nil }
  end

  describe 'a patient with an empty 11.1 address field' do
    before { load_fixture 'cdis_missing_address', '1234' }
    subject { Roqua::Healthy::A19.fetch('1234') }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('UMCG') }
    it { expect(subject[:identities]).to   eq([{ident: "1234", authority: "PI"}]) }
    it { expect(subject[:firstname]).to    eq('T.') }
    it { expect(subject[:initials]).to     eq('T.') }
    it { expect(subject[:lastname]).to     eq('Tester') }
    it { expect(subject[:display_name]).to eq(nil) }
    it { expect(subject[:nickname]).to     be_nil }
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

  describe 'epic epd example: a patient with no PID 8.1 (gender) field' do
    before { load_fixture 'epic_no_gender', '2001111' }
    subject { Roqua::Healthy::A19.fetch('2001111') }

    it { expect(subject[:status]).to       eq('SUCCESS') }
    it { expect(subject[:error]).to        be_nil }
    it { expect(subject[:source]).to       eq('UMCG') }
    it { expect(subject[:identities]).to   eq([{ident: "2001111", authority: "PI"}]) }
    it { expect(subject[:firstname]).to    eq('H') }
    it { expect(subject[:initials]).to     eq(nil) }
    it { expect(subject[:lastname]).to     eq("CLINT\u00C9N") }
    it { expect(subject[:display_name]).to eq(nil) }
    it { expect(subject[:email]).to        eq(nil) }
    it { expect(subject[:address_type]).to eq('M') }
    it { expect(subject[:street]).to       eq(nil) }
    it { expect(subject[:city]).to         eq(nil) }
    it { expect(subject[:zipcode]).to      eq(nil) }
    it { expect(subject[:country]).to      eq('NLD') }
    it { expect(subject[:birthdate]).to    eq('2001153') }
    it { expect(subject[:gender]).to       eq(nil) }
    it { expect(subject[:phone_cell]).to   eq(nil) }
  end
end
