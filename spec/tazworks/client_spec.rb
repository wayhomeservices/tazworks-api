# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tazworks::Client do
  let(:client) { described_class.new(ids: { clientGuid: TEST_DEFAULT_CLIENT_GUID }) }

  describe '.all' do
    it 'returns a ClientPagedResponse' do
      VCR.use_cassette('clients/all_clients') do
        expect(described_class.all(TEST_DEFAULT_CLIENT_GUID)).to be_a(Tazworks::ClientPagedResponse)
      end
    end
  end

  describe '.find' do
    it 'returns a Client' do
      VCR.use_cassette('clients/single_client') do
        pending 'Untestable - maintainer does not have a token that has permissions to this endpoint'
        expect(described_class.find({ clientGuid: TEST_DEFAULT_CLIENT_GUID })).to be_a(described_class)
      end
    end
  end

  describe '#create_applicant' do
    it 'calls Applicant.create' do
      expect(Tazworks::Applicant).to receive(:create).with(TEST_DEFAULT_CLIENT_GUID, { params: 'passed' })

      client.create_applicant({ params: 'passed' })
    end
  end
end
