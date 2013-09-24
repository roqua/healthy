require 'rspec'

require 'webmock/rspec'
WebMock.disable_net_connect!(:allow => "codeclimate.com")

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'healthy'

Healthy.a19_endpoint = "http://10.220.0.101:60101"