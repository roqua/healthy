def stub_mirth(patient_id = '123')
  stub_request(:post, Roqua::Healthy.a19_endpoint)
    .with(body: {application: 'healthy', method: 'A19', patient_id: patient_id})
end

def stub_mirth_response(response, status = 200, patient_id = '123')
  stub_mirth(patient_id).to_return(status: status, headers: {}, body: response)
end

def load_fixture(name, patient_id = '123')
  fixture_filename = File.expand_path(File.join(__FILE__, "../../fixtures", "#{name}.xml"))
  response = File.read(fixture_filename)
  stub_mirth_response(response, 200, patient_id)
end