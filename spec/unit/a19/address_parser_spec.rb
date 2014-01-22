require 'spec_helper'

describe Roqua::Healthy::A19::AddressParser do
  def msg(*types)
    addresses = []
    addresses << {'PID.11.7' => 'M',
                  'PID.11.1' => {'PID.11.1.1' => 'Mailstreet 1'},
                  'PID.11.3' => 'Mailcity',
                  'PID.11.5' => 'Mailzipcode',
                  'PID.11.6' => 'Mailcountry'
                  } if types.include?('M')
    addresses << {'PID.11.7' => 'H',
                  'PID.11.1' => {'PID.11.1.1' => 'Homestreet 1'},
                  'PID.11.3' => 'Homecity',
                  'PID.11.5' => 'Homezipcode',
                  'PID.11.6' => 'Homecountry'
                  } if types.include?('H')
    addresses << {'PID.11.7' => '?',
                  'PID.11.1' => {'PID.11.1.1' => '????street 1'},
                  'PID.11.3' => '????city',
                  'PID.11.5' => '????zipcode',
                  'PID.11.6' => '????country'
                  } if types.include?('?')
    {'PID' => {'PID.11' => addresses}}
  end

  describe '#address_type' do
    it 'returns M if mail address is present' do
      message = msg('M', 'H', '?')
      parser  = described_class.new(message)
      expect(parser.address_type).to eq("M")
    end

    it 'returns H if home address is present' do
      message = msg('H', '?')
      parser  = described_class.new(message)
      expect(parser.address_type).to eq("H")
    end

    it 'returns nil if no known address types are present' do
      message = msg('?')
      parser  = described_class.new(message)
      expect(parser.address_type).to be_nil
    end

    it 'returns nil if no addresses are present' do
      message = msg('?')
      parser  = described_class.new(message)
      expect(parser.address_type).to be_nil
    end
  end

  describe '#street' do
    it 'returns mail street' do
      message = msg('M', 'H', '?')
      parser  = described_class.new(message)
      expect(parser.street).to eq("Mailstreet 1")
    end

    it 'returns home street' do
      message = msg('H', '?')
      parser  = described_class.new(message)
      expect(parser.street).to eq("Homestreet 1")
    end

    it 'returns nil otherwise' do
      message = msg('?')
      parser  = described_class.new(message)
      expect(parser.street).to be_nil
    end
  end

  describe '#city' do
    it 'returns mail city' do
      message = msg('M', 'H', '?')
      parser  = described_class.new(message)
      expect(parser.city).to eq("Mailcity")
    end

    it 'returns home city' do
      message = msg('H', '?')
      parser  = described_class.new(message)
      expect(parser.city).to eq("Homecity")
    end

    it 'returns nil otherwise' do
      message = msg('?')
      parser  = described_class.new(message)
      expect(parser.city).to be_nil
    end
  end

  describe '#zipcode' do
    it 'returns mail zipcode' do
      message = msg('M', 'H', '?')
      parser  = described_class.new(message)
      expect(parser.zipcode).to eq("Mailzipcode")
    end

    it 'returns home zipcode' do
      message = msg('H', '?')
      parser  = described_class.new(message)
      expect(parser.zipcode).to eq("Homezipcode")
    end

    it 'returns nil otherwise' do
      message = msg('?')
      parser  = described_class.new(message)
      expect(parser.zipcode).to be_nil
    end
  end

  describe '#country' do
    it 'returns mail country' do
      message = msg('M', 'H', '?')
      parser  = described_class.new(message)
      expect(parser.country).to eq("Mailcountry")
    end

    it 'returns home country' do
      message = msg('H', '?')
      parser  = described_class.new(message)
      expect(parser.country).to eq("Homecountry")
    end

    it 'returns nil otherwise' do
      message = msg('?')
      parser  = described_class.new(message)
      expect(parser.country).to be_nil
    end
  end
end