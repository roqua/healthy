require 'roqua/support'

require 'roqua/healthy/version'
require 'roqua/healthy/message_cleaner'
require 'roqua/healthy/a19'
require 'roqua/healthy/client'
require 'roqua/healthy/errors'

module Roqua
  module Healthy
    class << self
      attr_accessor :a19_endpoint
    end
  end
end
