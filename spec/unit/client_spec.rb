# frozen_string_literal: true
require 'spec_helper'

describe Roqua::Healthy::Client do
  context 'fully configured client' do
    subject do
      Roqua::Healthy::Client.new(
        a19_endpoint: 'http://a19_endpoint.dev',
        a19_username: 'foo',
        a19_password: 'bar'
      )
    end

    it { expect(subject.a19_endpoint).to eq 'http://a19_endpoint.dev' }
    it { expect(subject.a19_username).to eq 'foo' }
    it { expect(subject.a19_password).to eq 'bar' }
    it { expect(subject.use_basic_auth?).to be_truthy }
  end

  context 'unconfigured client' do
    subject { Roqua::Healthy::Client.new }

    it 'defaults to system wide config' do
      expect(subject.a19_endpoint).to eq Roqua::Healthy.a19_endpoint
    end

    it { expect(subject.use_basic_auth?).to be_falsey }
  end
end
