require 'spec_helper'

describe 'Fetching remote patient details' do
  it 'returns transformed data' do
    pending
    load_fixture 'xmcare_patient_with_maiden_name'
    Healthy::A19.fetch("123").firstname.should == 'Babette'
  end
end