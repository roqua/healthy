require 'spec_helper'

describe 'Fetching A19 from CDIS' do
  describe 'the patient Jan Fictief' do
    before { load_fixture 'cdis_jan_fictief', '7767853' }
    subject { Healthy::A19.fetch("7767853") }

    its([:status])       { should == :todo }
    its([:channel])      { should == :todo }
    its([:error])        { should == nil }
    its([:source])       { should == 'UMCG' }
    its([:identities])   { should == [{ident: '7767853', authority: 'PI'}] }
    its([:firstname])    { should == 'Jan' }
    its([:initials])     { should == 'J.A.B.C.' }
    its([:lastname])     { should == 'Fictief' }
    its([:display_name]) { should == nil }
    its([:email])        { should == nil }
    its([:address_type]) { should == :todo }
    its([:street])       { should == :todo }
    its([:city])         { should == :todo }
    its([:zipcode])      { should == :todo }
    its([:country])      { should == :todo }
    its([:birthdate])    { should == '19800101' }
    its([:gender])       { should == 'M' }
  end

  describe 'the patient Piet Fictief' do
    before { load_fixture 'cdis_piet_fictief', '7718758' }
    subject { Healthy::A19.fetch("7718758") }

    its([:status])       { should == :todo }
    its([:channel])      { should == :todo }
    its([:error])        { should == nil }
    its([:source])       { should == 'UMCG' }
    its([:identities])   { should == [{ident: '7718758', authority: 'PI'}] }
    its([:firstname])    { should == 'Piet' }
    its([:initials])     { should == 'P.X.X.X.' }
    its([:lastname])     { should == 'Fictief' }
    its([:display_name]) { should == nil }
    its([:email])        { should == nil }
    its([:address_type]) { should == :todo }
    its([:street])       { should == :todo }
    its([:city])         { should == :todo }
    its([:zipcode])      { should == :todo }
    its([:country])      { should == :todo }
    its([:birthdate])    { should == '19121212' }
    its([:gender])       { should == 'M' }
  end

  describe 'the patient Gerda Geit' do
    before { load_fixture 'cdis_gerda_geit', '7078387' }
    subject { Healthy::A19.fetch("7078387") }

    its([:status])       { should == :todo }
    its([:channel])      { should == :todo }
    its([:error])        { should == nil }
    its([:source])       { should == 'UMCG' }
    its([:identities])   { should == [{ident: '7078387', authority: 'PI'}, {ident: '003704397', authority: 'NNNLD'}] }
    its([:firstname])    { should == 'Gerda' }
    its([:initials])     { should == 'G.' }
    its([:lastname])     { should == 'Geit' }
    its([:display_name]) { should == nil }
    its([:email])        { should == nil }
    its([:address_type]) { should == :todo }
    its([:street])       { should == :todo }
    its([:city])         { should == :todo }
    its([:zipcode])      { should == :todo }
    its([:country])      { should == :todo }
    its([:birthdate])    { should == '19880101' }
    its([:gender])       { should == 'F' }
  end

end