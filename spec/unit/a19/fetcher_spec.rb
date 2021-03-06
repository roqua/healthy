# frozen_string_literal: true
require 'spec_helper'

describe Roqua::Healthy::A19::Fetcher do
  let(:client) { Roqua::Healthy::Client.new }

  subject { Roqua::Healthy::A19::Fetcher.new("123", client) }

  it 'succeeds when upstream returns XML' do
    stub_mirth_response("<HL7Message></HL7Message>")
    expect { subject.fetch }.not_to raise_error
  end

  it "raises when upstream does not return HTTP 200" do
    stub_mirth_response "Request not successful", 500
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::IllegalMirthResponse)
  end

  it 'raises when upstream responds with illegal XML' do
    stub_mirth_response "<patient><firstname>Jan & Piet</firstname></patient>"
    expect { subject.fetch }.to raise_error(Roqua::Healthy::IllegalMirthResponse)

    stub_mirth_response "<patient><firstname>Jan</patient>"
    expect { subject.fetch }.to raise_error(Roqua::Healthy::IllegalMirthResponse)
  end

  it "raises upstream is returning old style 'Timeout waiting for ACK' messages" do
    stub_mirth_response "<failure><error>Timeout waiting for ACK</error></failure>", 500
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end

  it "raises upstream is returning new style 'Timeout waiting for response' messages" do
    stub_mirth_response "<failure><error>ERROR: Timeout waiting for response</error></failure>", 500
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end

  it "raises upstream is returning 'connection timeout' messages" do
    stub_mirth_response "<failure><error>Unable to connect to destination\tSocketTimeoutException\tconnect timed out</error></failure>", 500
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end

  it "raises if upstream is returning old style 'connection refused' messages" do
    stub_mirth_response "<failure><error>Unable to connect to destination\tConnectException\tConnection refused</error></failure>", 500
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::ConnectionRefused)
  end

  it "raises if upstream is returning new  style 'connection refused' messages" do
    stub_mirth_response "<failure><error>ERROR: ConnectException: Connection refused</error></failure>", 500
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::ConnectionRefused)
  end

  it "raises when upstream does not accept connections" do
    stub_mirth.to_raise Errno::ECONNREFUSED
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::ConnectionRefused)
  end

  it 'raises when upstream is unreachable' do
    stub_mirth.to_raise Errno::EHOSTUNREACH
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::HostUnreachable)
  end

  it "raises when upstream is timing out" do
    stub_mirth.to_timeout
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::Timeout)

    stub_mirth.to_raise Errno::ETIMEDOUT
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::Timeout)
  end

  it 'raises when upstream authentication fails' do
    stub_mirth_response "<failure><error>Unauthorized</error></failure>", 401
    expect { subject.fetch }.to raise_exception(Roqua::Healthy::AuthenticationFailure)
  end

  it 'saves the client' do
    expect(subject.client).to eq client
  end

  describe '#remote_url' do
    let(:fetcher) { Roqua::Healthy::A19::Fetcher.new("123", client) }
    it 'uses the client config if available' do
      expect(client).to receive(:a19_endpoint).and_call_original
      fetcher.send(:remote_url)
    end
  end
end
