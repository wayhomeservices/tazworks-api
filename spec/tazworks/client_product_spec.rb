# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tazworks::ClientProduct do
  describe '.all' do
    before do
      VCR.use_cassette('clients/client_products/all_client_products') do
        @response = described_class.all(TEST_DEFAULT_CLIENT_GUID)
      end
    end

    it 'returns a ClientProductPagedResponse' do
      expect(@response).to be_a Tazworks::ClientProductPagedResponse
    end

    it 'returns all the client products for a client' do
      expect(@response.client_products.count).to be(4)
    end

    it 'returns a ClientProduct in the response' do
      expect(@response.client_products.first).to be_a described_class
      expect(@response.client_products.first.ids.keys).to eql(%i[clientGuid clientProductGuid])
    end

    it 'returns the proper ClientProductGuid in each object' do
      @response.client_products.each do |cp|
        expect(cp.clientProductGuid).to eql(cp.attributes[:clientProductGuid])
      end
    end
  end

  describe '.find' do
    before do
      VCR.use_cassette('clients/client_products/client_product_details') do
        pending 'Untestable - maintainer does not have a token that has permissions to this endpoint'
        @response = described_class.find({ clientGuid: TEST_DEFAULT_CLIENT_GUID,
                                           clientProductGuid: TEST_DEFAULT_CLIENT_PRODUCT_GUID })
      end
    end

    it 'returns a ClientProduct' do
      expect(@response).to be_a(described_class)
    end
  end
end
