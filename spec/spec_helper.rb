require 'rspec'

require 'webmock/rspec'
WebMock.disable_net_connect! allow: "codeclimate.com"

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["spec/support/**/*.rb"].each { |filename| load filename }

require 'healthy'
Healthy.a19_endpoint = "http://10.220.0.101:60101"