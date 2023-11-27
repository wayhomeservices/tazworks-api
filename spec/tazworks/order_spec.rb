# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tazworks::Order do
  describe '.all' do
    before do
      VCR.use_cassette('orders/all_orders') do
        @response = described_class.all(TEST_DEFAULT_CLIENT_GUID)
      end
    end

    it 'returns a OrderPagedResponse' do
      expect(@response).to be_a Tazworks::OrderPagedResponse
    end

    it 'returns all the orders for a client' do
      expect(@response.orders.count).to be(15)
    end

    it 'returns a Order in the response' do
      expect(@response.orders.first).to be_a described_class
      expect(@response.orders.first.ids.keys).to eql(%i[clientGuid orderGuid])
    end
  end

  describe '.find' do
    before do
      VCR.use_cassette('orders/single_order') do
        @response = described_class.find({ clientGuid: TEST_DEFAULT_CLIENT_GUID, orderGuid: TEST_DEFAULT_ORDER_GUID })
      end
    end

    it 'returns a Order' do
      expect(@response).to be_a(described_class)
    end
  end

  describe '.create' do
    context 'when all the required parameters are passed' do
      let(:params) do
        {
          applicantGuid: TEST_DEFAULT_APPLICANT_GUID,
          clientProductGuid: TEST_DEFAULT_CLIENT_PRODUCT_GUID,
          useQuickApp: true
        }
      end

      before do
        VCR.use_cassette('orders/submit_order') do
          @response = described_class.create(TEST_DEFAULT_CLIENT_GUID, params)
        end
      end

      it 'creates a new order' do
        expect(@response).to be_a(described_class)
      end

      it 'sets the ids correctly' do
        expect(@response.ids).to eql({ orderGuid: '32d9351f-186e-4320-a828-f3afbd584c3a',
                                       clientGuid: TEST_DEFAULT_CLIENT_GUID })
      end
    end

    context 'when a required parameter is missing from params' do
      let(:params) do
        {
          applicantGuid: TEST_DEFAULT_APPLICANT_GUID
        }
      end

      it 'raises an ArgumentError' do
        expect do
          described_class.create(TEST_DEFAULT_CLIENT_GUID, params)
        end.to raise_error(ArgumentError, 'clientProductGuid is missing in params hash.')
      end
    end
  end

  describe '#order_status' do
    let(:order) do
      described_class.new(ids: { clientGuid: TEST_DEFAULT_CLIENT_GUID, orderGuid: TEST_DEFAULT_ORDER_GUID })
    end

    before do
      VCR.use_cassette('orders/order_status') do
        @response = order.order_status
      end
    end

    it 'returns a order_status hash' do
      expected = { 'coApplicantDetails' => [],
                   'orderDetail' => {
                     'externalIdentifier' => '10001a',
                     'fileNumber' => 572_352,
                     'reportUrl' => 'https://lightning.instascreen.net/send/interchangeview/?a=<screened>&b=365&c=rptview&file=<screened>',
                     'reportUrlLoginRequired' => 'https://lightning.instascreen.net/editor/viewReport.taz?file=<screened>',
                     'status' => 'complete'
                   } }
      expect(@response).to eql(expected)
    end
  end

  describe '#results_as_pdf' do
    context 'when the pdf is available' do
      let(:order) do
        described_class.new(ids: { clientGuid: TEST_DEFAULT_CLIENT_GUID, orderGuid: TEST_DEFAULT_ORDER_GUID })
      end

      before do
        VCR.use_cassette('orders/order_results_as_pdf') do
          @response = order.results_as_pdf
        end
      end

      it 'returns pdf url' do
        expect(@response).to eql('https://lightning.instascreen.net/send/interchangeview/?a=<filtered>&b=365&c=rptview&file=<filtered>&format=pdf')
      end
    end

    context 'when the pdf is not available' do
      let(:order) do
        described_class.new(ids: { clientGuid: TEST_DEFAULT_CLIENT_GUID,
                                   orderGuid: '32d9351f-186e-4320-a828-f3afbd584c3a' })
      end

      it 'returns an exception' do
        expected_exception_message = '{"code":"VALIDATION_EXCEPTION",' \
                                     '"message":"Report results are not available for orders in app-pending status."}'
        VCR.use_cassette('orders/order_results_as_pdf-pdf_unavailable') do
          expect do
            order.results_as_pdf
          end.to raise_exception(Tazworks::Error, expected_exception_message)
        end
      end
    end
  end
end
