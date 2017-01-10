# frozen_string_literal: true
require 'spec_helper'

describe Roqua::Healthy::A19::ResponseValidator do
  describe '#validate' do
    subject { Roqua::Healthy::A19::ResponseValidator.new('500', double(fetch: {'error' => error}), 123) }
    let(:error) { self.class.description }

    context "Timeout waiting for ACK" do
      it 'raises ::Roqua::Healthy::Timeout' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::Timeout)
      end
    end

    context 'ERROR: Timeout waiting for response' do
      it 'raises ::Roqua::Healthy::Timeout' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::Timeout)
      end
    end

    context "Unable to connect to destination\tSocketTimeoutException\tconnect timed out" do
      it 'raises ::Roqua::Healthy::Timeout' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::Timeout)
      end
    end

    context 'ERROR: SocketTimeoutException: connect timed out' do
      it 'raises ::Roqua::Healthy::Timeout' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::Timeout)
      end
    end

    context "Unable to connect to destination\tConnectException\tConnection refused" do
      it 'raises ::Roqua::Healthy::Timeout' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::ConnectionRefused)
      end
    end

    context 'ERROR: ConnectException: Connection refused' do
      it 'raises ::Roqua::Healthy::Timeout' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::ConnectionRefused)
      end
    end

    context 'Unknown error' do
      it 'raises ::Roqua::Healthy::UnknownFailure' do
        expect { subject.validate }.to raise_error(::Roqua::Healthy::UnknownFailure)
      end
    end
  end
end
