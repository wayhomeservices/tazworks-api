# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tazworks::Config do
  before(:all) do
    @original_config = Tazworks.instance_variable_get(:@config)
  end

  after(:all) do
    Tazworks.instance_variable_set(:@config, @original_config)
  end

  before do
    Tazworks.instance_variable_set(:@config, nil)
  end

  describe '#base_uri' do
    context 'when passing no host or port' do
      it 'returns the production base_uri' do
        expect(Tazworks.config.base_uri.to_s).to eql('https://api.instascreen.net')
      end
    end

    context 'when passing sandbox: true' do
      before do
        Tazworks.configure do |c|
          c.sandbox = true
        end
      end

      it 'returns to the staging base_uri' do
        expect(Tazworks.config.base_uri.to_s).to eql('https://api-sandbox.instascreen.net')
      end
    end

    context 'when passing a custom host' do
      before do
        Tazworks.configure do |c|
          c.host = 'https://api-sandbox.acmescreen.net'
        end
      end

      it 'returns the custom base_uri' do
        expect(Tazworks.config.base_uri.to_s).to eql('https://api-sandbox.acmescreen.net')
      end
    end
  end
end
