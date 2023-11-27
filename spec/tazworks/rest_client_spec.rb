# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tazworks::RestClient do
  before(:all) do
    @original_config = Tazworks.instance_variable_get(:@config)
  end

  after(:all) do
    Tazworks.instance_variable_set(:@config, @original_config)
  end

  describe '::url' do
    it 'appends the uri to the host and creates a proper url' do
      expect(described_class.url('/v1/test/something')).to eql('https://api-sandbox.instascreen.net/v1/test/something')
    end
  end

  describe '::merged_headers' do
    before do
      Tazworks.configure do |c|
        c.api_key = 'testkey123'
      end
    end

    context 'when passing headers' do
      it 'merges with default configuration' do
        result = described_class.merged_headers({ more: 'params' })
        expect(result).to eql({
                                'Content-Type': 'application/json',
                                Authorization: 'Bearer testkey123',
                                more: 'params'
                              })
      end
    end

    context 'when passed headers override default' do
      it 'returns the overrided values' do
        result = described_class.merged_headers({ Authorization: 'overriden' })
        expect(result).to eql({
                                'Content-Type': 'application/json',
                                Authorization: 'overriden'
                              })
      end
    end
  end
end
