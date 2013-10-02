require 'spec_helper'

describe 'Fetching A19 from Medo' do
  describe 'a patient' do
    before { load_fixture 'medo_patient', 'md-cdae5d100d8e0131d2623c075478eb56' }
    subject { Healthy::A19.fetch("md-cdae5d100d8e0131d2623c075478eb56") }

    its([:status])       { should == 'SUCCESS' }
    its([:error])        { should == nil }
    its([:source])       { should == 'RGOC' }
    its([:identities])   { should == [{ident: 'md-cdae5d100d8e0131d2623c075478eb56', authority: 'epd'}] }
    its([:firstname])    { should == 'Jan' }
    its([:initials])     { should == 'J.' }
    its([:lastname])     { should == 'Fictief' }
    its([:display_name]) { should == nil }
    its([:email])        { should == 'j.fictief@roqua.nl' }
    its([:address_type]) { should == 'H' }
    its([:street])       { should == 'Thuisstraat 42' }
    its([:city])         { should == 'GRUNN' }
    its([:zipcode])      { should == '1234QQ' }
    its([:country])      { should == 'Nederland' }
    its([:birthdate])    { should == '19800525' }
    its([:gender])       { should == 'M' }
  end
end