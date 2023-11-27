# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tazworks::Applicant do
  describe '.get' do
    let(:ids) { { clientGuid: TEST_DEFAULT_CLIENT_GUID, applicantGuid: TEST_DEFAULT_APPLICANT_GUID } }

    before do
      VCR.use_cassette('orders/applicants/single_applicant') do
        @response = described_class.get(ids)
      end
    end

    it 'returns a response' do
      expect(@response).to be_a(RestClient::Response)
    end

    it 'returns a JSON Parsable body' do
      expect(JSON.parse(@response)).to be_a(Hash)
    end
  end

  describe '.create' do
    context 'when all the required parameters are passed' do
      let(:params) do
        {
          firstName: 'Bob',
          lastName: 'Smith',
          email: 'bob.smith@gmail.com'
        }
      end

      before do
        VCR.use_cassette('orders/applicants/create_applicant') do
          @response = described_class.create(TEST_DEFAULT_CLIENT_GUID, params)
        end
      end

      it 'creates a new applicant' do
        expect(@response).to be_a(described_class)
      end

      it 'sets the ids correctly' do
        expect(@response.ids).to eql({ applicantGuid: TEST_DEFAULT_APPLICANT_GUID,
                                       clientGuid: TEST_DEFAULT_CLIENT_GUID })
      end
    end

    context 'when lastName is missing from params' do
      let(:params) do
        {
          firstName: 'Bob',
          email: 'bob.smith@gmail.com'
        }
      end

      it 'raises an ArgumentError' do
        expect do
          described_class.create(TEST_DEFAULT_CLIENT_GUID, params)
        end.to raise_error(ArgumentError, 'lastName is missing in params hash.')
      end
    end
  end

  describe '.all' do
    context 'when size and page is not specified and there is only a single page' do
      before do
        # Not sure if the endpoints organization makes sense, but following the documentation layout
        VCR.use_cassette('orders/applicants/all_applicants') do
          @response = described_class.all(TEST_DEFAULT_CLIENT_GUID)
        end
      end

      it 'returns an ApplicantPagedResponse' do
        expect(@response).to be_a(Tazworks::ApplicantPagedResponse)
      end

      describe '#next_page' do
        it 'returns nil' do
          expect(@response.next_page).to be_nil
        end
      end

      describe '#total_number_of_pages' do
        it 'returns 0 (indicating there are no extra pages)' do
          expect(@response.total_number_of_pages).to be(0)
        end
      end
    end

    context 'when size is specified' do
      before do
        VCR.use_cassette('orders/applicants/all_applicants_page_size_defined') do
          @response = described_class.all(TEST_DEFAULT_CLIENT_GUID, { size: 3 })
        end
      end

      it 'returns a ApplicantPagedResponse' do
        expect(@response).to be_a(Tazworks::ApplicantPagedResponse)
      end

      it 'returns the correct number of applicants' do
        expect(@response.applicants.count).to be(3)
      end

      describe '#next_page' do
        it 'returns the next page number' do
          expect(@response.next_page).to be(1)
        end
      end

      describe '#total_number_of_pages' do
        it 'returns the last page number' do
          expect(@response.total_number_of_pages).to be(8)
        end
      end
    end
  end
end
