require 'spec_helper'

describe Roqua::Healthy::A19::Fetcher do
  it 'succeeds when upstream returns XML' do
    stub_mirth_response("<HL7Message></HL7Message>")
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.not_to raise_error
  end

  it "raises when upstream does not return HTTP 200" do
    stub_mirth_response "Request not successful", 500
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception
  end

  it 'raises when upstream responds with illegal XML' do
    stub_mirth_response "<patient><firstname>Jan & Piet</firstname></patient>"
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_error(Roqua::Healthy::IllegalMirthResponse)

    stub_mirth_response "<patient><firstname>Jan</patient>"
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_error(Roqua::Healthy::IllegalMirthResponse)
  end

  it "raises upstream is returning 'Timeout waiting for ACK' messages" do
    stub_mirth_response "<failure><error>Timeout waiting for ACK</error></failure>", 500
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end

  it "raises upstream is returning 'connection timeout' messages" do
    stub_mirth_response "<failure><error>Unable to connect to destination\tSocketTimeoutException\tconnect timed out</error></failure>", 500
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end

  it "raises upstream is returning 'connection refuesed' messages" do
    stub_mirth_response "<failure><error>Unable to connect to destination\tConnectException\tConnection refused</error></failure>", 500
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::ConnectionRefused)
  end

  it "raises when upstream does not accept connections" do
    stub_mirth.to_raise Errno::ECONNREFUSED
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::ConnectionRefused)
  end

  it 'raises when upstream is unreachable' do
    stub_mirth.to_raise Errno::EHOSTUNREACH
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::HostUnreachable)
  end

  it "raises when upstream is timing out" do
    stub_mirth.to_timeout
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::Timeout)

    stub_mirth.to_raise Errno::ETIMEDOUT
    expect { Roqua::Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end
end
