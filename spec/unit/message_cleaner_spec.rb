require 'spec_helper'

describe MessageCleaner do
  let(:message) { {key: ""} }

  describe '#message' do
    it 'leaves clean messages untouched' do
      message = {key: 'value', other_key: double}
      cleaned = MessageCleaner.new(message).message
      expect(cleaned).to eq(message)
    end

    it 'cleans strings that contain only a pair of double quotes' do
      message = {key: '""'}
      cleaned = MessageCleaner.new(message).message
      expect(cleaned).to eq(key: '')
    end

    it 'cleans strings in subhashes' do
      message = {key: {subkey: '""'}}
      cleaned = MessageCleaner.new(message).message
      expect(cleaned).to eq(key: {subkey: ''})
    end

    it 'cleans strings in arrays' do
      message = {key: [{subkey: '""'}, {subkey: 'foo'}]}
      cleaned = MessageCleaner.new(message).message
      expect(cleaned).to eq(key: [{subkey: ''}, {subkey: 'foo'}])
    end
  end

  describe '#clean_string' do
    let(:cleaner) { MessageCleaner.new("") }

    it 'does not change clean strings' do
      expect(cleaner.clean_string("a string")).to eq("a string")
    end

    it 'strips whitespace' do
      expect(cleaner.clean_string("   a string  ")).to eq("a string")
    end

    it 'sanitizes strings that are only a pair of double quotes' do
      expect(cleaner.clean_string('""')).to eq('')
    end
  end
end