require 'spec_helper'

describe Healthy::A19::Fetcher do
  it 'succeeds when upstream returns XML' do
    stub_mirth_response("<HL7Message></HL7Message>")
    expect { Healthy::A19::Fetcher.new("123").fetch }.not_to raise_error
  end

  it "raises when upstream does not return HTTP 200" do
    stub_mirth_response "Request not successful", 403
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception
  end

  it 'raises when upstream responds with illegal XML' do
    stub_mirth_response "<patient><firstname>Jan & Piet</firstname></patient>"
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_error(Healthy::IllegalMirthResponse)

    stub_mirth_response "<patient><firstname>Jan</patient>"
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_error(Healthy::IllegalMirthResponse)
  end

  it "returns an error when upstream is returning ACK timeouts" do
    pending
    stub_mirth_response "<patient>
                  <status>FAILURE</status>
                  <channel>Meerkanten - Outbound port 60401</channel>
                  <error>Timeout waiting for ACK</error>
                </patient>"

    response = Healthy::A19::Fetcher.new("123").fetch
    response["status"].should eq("FAILURE")
    response["error"].should =~ /Timeout waiting for ACK/
  end

  it "raises when upstream does not accept connections" do
    stub_mirth.to_raise Errno::ECONNREFUSED
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Healthy::ConnectionRefused)
  end

  it 'raises when upstream is unreachable' do
    stub_mirth.to_raise Errno::EHOSTUNREACH
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Healthy::HostUnreachable)
  end

  it "raises when upstream is timing out" do
    stub_mirth.to_timeout
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Healthy::Timeout)

    stub_mirth.to_raise Errno::ETIMEDOUT
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Healthy::Timeout)
  end
end
