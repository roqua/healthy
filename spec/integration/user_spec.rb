require 'spec_helper'

describe 'Fetching A19 from USER' do
  describe 'a patient' do
    before { load_fixture 'user_patient', '00000123' }
    subject { Healthy::A19.fetch("00000123") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'IMPULSE' }
    its([:identities])   { should == [{ident: '000123', authority: 'PI'}] }
    its([:firstname])    { should == 'Alice' }
    its([:initials])     { should == 'A.B.' }
    its([:lastname])     { should == 'Achternaam' }
    its([:display_name]) { should be_nil }
    its([:email])        { should be_nil }
    its([:address_type]) { should == 'L' }
    its([:street])       { should == 'Straatnaam 37' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234 AB' }
    its([:country])      { should == '6030' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'M' }
    its([:phone_cell])   { should be_nil }
  end

  describe 'a patient' do
    before { load_fixture 'user_patient_with_maiden_name', '00000123' }
    subject { Healthy::A19.fetch("00000123") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'IMPULSE' }
    its([:identities])   { should == [{ident: '00000123', authority: 'PI'}] }
    its([:firstname])    { should == 'Babette' }
    its([:initials])     { should == 'A.B.C.' }
    its([:lastname])     { should == 'Achternaam' }
    its([:display_name]) { should be_nil }
    its([:email])        { should be_nil }
    its([:address_type]) { should == 'L' }
    its([:street])       { should == 'Straatnaam 37' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234 AB' }
    its([:country])      { should == '6030' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'F' }
    its([:phone_cell])   { should be_nil }
  end

  describe 'a patient with gsm number and email address' do
    before { load_fixture 'user_patient_with_gsm_and_email', '00000033' }
    subject { Healthy::A19.fetch("00000033") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'IMPULSE' }
    its([:identities])   { should == [{ident: '00000033', authority: 'PI'}] }
    its([:firstname])    { should == 'Albert' }
    its([:initials])     { should == 'A.' }
    its([:lastname])     { should == "Pati\u00EBnt" }
    its([:display_name]) { should be_nil }
    its([:email])        { should == 'apatient@info.nl' }
    its([:address_type]) { should == 'L' }
    its([:street])       { should == 'Straatnaam 37' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234 AB' }
    its([:country])      { should == '6030' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'M' }
    its([:phone_cell])   { should be_nil }
  end
end