# frozen_string_literal: true
require 'spec_helper'

describe Roqua::Healthy::Client do
  before do
    ENV['RAILS_ENV'] = 'test'
    allow_any_instance_of(Vault::Logical).to receive(:read).with("secret/medo/test/a19_basic_auth").and_return(
      OpenStruct.new(
        data: {
          username: 'foo',
          password: 'bar'
        }
      )
    )
  end

  context 'fully configured client' do
    subject { Roqua::Healthy::Client.new(a19_endpoint: 'http://a19_endpoint.dev') }

    it { expect(subject.a19_endpoint).to eq 'http://a19_endpoint.dev' }
  end

  context 'unconfigured client' do
    subject { Roqua::Healthy::Client.new }

    it 'defaults to system wide config' do
      expect(subject.a19_endpoint).to eq Roqua::Healthy.a19_endpoint
    end
  end
end
