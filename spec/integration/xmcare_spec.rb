require 'spec_helper'

describe 'Fetching A19 from XMcare' do
  describe 'a patient' do
    before { load_fixture 'xmcare_patient', '12345678901' }
    subject { Healthy::A19.fetch("12345678901") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'ZIS' }
    its([:identities])   { should == [{ident: '12345678901', authority: 'PI'}, {ident: '123456789',   authority: 'NNNLD'}] }
    its([:firstname])    { should == 'Babette' }
    its([:initials])     { should == 'A B' }
    its([:lastname])     { should == 'Achternaam' }
    its([:display_name]) { should == 'Achternaam' }
    its([:email])        { should == '' }
    its([:address_type]) { should == 'H' }
    its([:street])       { should == 'Straatnaam 37' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234AB' }
    its([:country])      { should == 'NL' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'F' }
  end

  describe 'a patient with a maiden name' do
    before { load_fixture 'xmcare_patient_with_maiden_name', '12345678901' }
    subject { Healthy::A19.fetch("12345678901") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'ZIS' }
    its([:identities])   { should == [{ident: '12345678901', authority: 'PI'}, {ident: '123456789',   authority: 'NNNLD'}] }
    its([:firstname])    { should == 'Babette' }
    its([:initials])     { should == 'A B' }
    its([:lastname])     { should == 'Achternaam' }
    its([:display_name]) { should == 'Meisjesnaam - Achternaam' }
    its([:email])        { should == 'email@example.com' }
    its([:address_type]) { should == 'H' }
    its([:street])       { should == 'Straatnaam 37' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234AB' }
    its([:country])      { should == 'NL' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'F' }
  end

  describe 'a patient with a maiden name' do
    before { load_fixture 'xmcare_patient_email_in_field_number_four', '12345678901' }
    subject { Healthy::A19.fetch("12345678901") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'ZIS' }
    its([:identities])   { should == [{ident: '12345678901', authority: 'PI'}, {ident: '123456789',   authority: 'NNNLD'}] }
    its([:firstname])    { should == 'Babette' }
    its([:initials])     { should == 'A B' }
    its([:lastname])     { should == 'Achternaam' }
    its([:display_name]) { should == 'Achternaam' }
    its([:email])        { should == 'email@example.com' }
    its([:address_type]) { should == 'H' }
    its([:street])       { should == 'Straatnaam 37' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234AB' }
    its([:country])      { should == 'NL' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'F' }
  end

  describe 'a patient that does not exist' do
    before { load_fixture 'xmcare_patient_not_found', '12345678901' }

    it 'raises PatientNotFound' do
      expect { Healthy::A19.fetch("12345678901") }.to raise_error(Healthy::PatientNotFound)
    end
  end
end