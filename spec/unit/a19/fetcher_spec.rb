require 'spec_helper'

describe Healthy::A19::Fetcher do
  it 'succeeds when upstream returns XML' do
    stub_mirth_response("<HL7Message></HL7Message>")
    expect { Healthy::A19::Fetcher.new("123").fetch }.not_to raise_error
  end

  it "raises when upstream does not return HTTP 200" do
    stub_mirth_response "Request not successful", 500
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception
  end

  it 'raises when upstream responds with illegal XML' do
    stub_mirth_response "<patient><firstname>Jan & Piet</firstname></patient>"
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_error(Healthy::IllegalMirthResponse)

    stub_mirth_response "<patient><firstname>Jan</patient>"
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_error(Healthy::IllegalMirthResponse)
  end

  it "raises upstream is returning 'Timeout waiting for ACK' messages" do
    stub_mirth_response "<failure><error>Timeout waiting for ACK</error></failure>", 500
    expect { Healthy::A19::Fetcher.new("123").fetch }.to raise_exception(Healthy::Timeout)
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
