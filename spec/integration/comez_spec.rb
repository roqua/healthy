require 'spec_helper'

describe 'Fetching A19 from Comez' do
  describe 'a patient' do
    before { load_fixture 'comez_patient', '0000123456' }
    subject { Healthy::A19.fetch("0000123456") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should be_nil }
    its([:source])       { should == 'CS' }
    its([:identities])   { should == [{ident: '0000123456', authority: 'PI'}, {ident: '123456789',   authority: 'NNNLD'}] }
    its([:firstname])    { should == 'Voornaam' }
    its([:initials])     { should == 'A' }
    its([:lastname])     { should == 'Achternaam' }
    its([:display_name]) { should be_nil }
    its([:email])        { should be_nil }
    its([:address_type]) { should == 'M' }
    its([:street])       { should == 'Postadresstraat 42' }
    its([:city])         { should == 'PLAATSNAAM' }
    its([:zipcode])      { should == '1234AB' }
    its([:country])      { should == 'NL' }
    its([:birthdate])    { should == '17070415' }
    its([:gender])       { should == 'F' }
    its([:phone_cell])   { should be_nil }
  end
end