require 'healthy/version'
require 'healthy/message_cleaner'
require 'healthy/a19'
require 'healthy/errors'

module Healthy
  class << self
    attr_accessor :a19_endpoint
  end
end