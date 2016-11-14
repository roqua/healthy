# frozen_string_literal: true
module Roqua
  module Healthy
    class MessageCleaner
      def initialize(message)
        @message = message
      end

      def message
        clean_hash(@message)
      end

      def clean(thing)
        case thing
        when Hash
          clean_hash(thing)
        when Array
          clean_array(thing)
        when String
          clean_string(thing)
        else
          thing
        end
      end

      def clean_hash(hash)
        hash.each do |key, value|
          hash[key] = clean(value)
        end
        hash
      end

      def clean_array(array)
        array.map do |value|
          clean(value)
        end
      end

      def clean_string(string)
        return '' if string == '""'
        string.strip
      end
    end
  end
end
