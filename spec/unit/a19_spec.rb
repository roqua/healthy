require 'spec_helper'

describe Healthy::A19 do
  describe "#remote" do
    let(:a19) { Healthy::A19.new("1") }

    before do
      @remote_url = "http://10.220.0.101:60101/"
    end

    def stub_mirth(response, status = 200)
      stub_request(:post, @remote_url)
        .with(body: "method=A19&patient_id=1",
              headers: {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded'})
        .to_return(status: status,
                   body: response,
                   headers: {})
    end

    context "when upstream is responding" do
      context "for an epd_id which upstream knows"
      context "for an epd_id which upstream does not know"

      it 'succeeds when upstream returns an ACK without patient details' do
        stub_mirth("<patient> <status>SUCCESS</status> </patient>")
        expect { a19.fetch }.not_to raise_error
      end

      it 'succeeds with only one returned identity' do
        stub_mirth("<patient>
                      <identities><ident>1</ident></identities>
                    </patient>")

        response = a19.fetch
        response["identities"].should eq([{'ident' => '1'}])
      end

      it 'filters empty identities' do
        stub_mirth("<patient>
                      <identities><ident></ident></identities>
                      <identities><ident>\"\"</ident></identities>
                      <identities><ident>1</ident></identities>
                    </patient>")

        response = a19.fetch
        response["identities"].should eq([{'ident' => '1'}])
      end

      it "returns an error when upstream is returning ACK timeouts" do
        stub_mirth "<patient>
                      <status>FAILURE</status>
                      <channel>Meerkanten - Outbound port 60401</channel>
                      <error>Timeout waiting for ACK</error>
                    </patient>"

        response = a19.fetch
        response["status"].should eq("FAILURE")
        response["error"].should =~ /Timeout waiting for ACK/
      end

      it "raises when upstream does not return HTTP 200" do
        stub_mirth "Request not successful", 403
        expect { a19.fetch }.to raise_exception
      end

      it "raises when upstream returns the wrong patient" do
        stub_mirth "<patient>
                      <identities><ident>2</ident></identities>
                      <identities><ident>3</ident></identities>
                    </patient>"
        expect { a19.fetch }.to raise_error(/Patient ID not in remote details/)
      end

      it 'raises when upstream responds with illegal XML' do
        stub_mirth "<patient><firstname>Jan & Piet</firstname></patient>"
        expect { a19.fetch }.to raise_error(Healthy::IllegalMirthResponse)
      end
    end

    context 'when upstream is not responding' do
      it "raises when upstream does not accept connections" do
        stub_request(:any, @remote_url).to_raise Errno::ECONNREFUSED
        expect { a19.fetch }.to raise_exception(Healthy::ConnectionRefused)
      end

      it "raises when upstream is timing out" do
        stub_request(:any, @remote_url).to_timeout
        expect { a19.fetch }.to raise_exception(Healthy::Timeout)
      end
    end
  end
end