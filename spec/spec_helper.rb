# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

require 'rspec'

require 'webmock/rspec'
require 'vault'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["spec/support/**/*.rb"].each { |filename| load filename }

require 'roqua/healthy'
Roqua::Healthy.a19_endpoint = "http://10.220.0.101:60101"

require 'stringio'
LOG_FILE = StringIO.new
Roqua.logger = Logger.new(LOG_FILE)

RSpec.configure do |config|
  config.before(:each) do
    # Simulate Vault usage
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

  config.after(:suite) do
    if ENV["DEBUG"]
      LOG_FILE.rewind
      puts "", "Log file: ", LOG_FILE.read
    end
  end
end
