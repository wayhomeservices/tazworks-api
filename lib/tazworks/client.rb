# frozen_string_literal: true

module Tazworks
  # Tazworks Clients Model
  class Client < Model
    # https://docs.developer.tazworks.com/#3a09caba-349b-4969-a55a-1cbcaea0136c
    # TODO: WARNING - UNTESTED - maintainer doesn't have a proper token for this endpoint!
    def self.get(ids)
      RestClient.get("/v1/clients/#{ids[:clientGuid]}")
    end

    # https://docs.developer.tazworks.com/#e008c159-b8d7-4843-a08f-ff483315a067
    # tazapi defaults to params { page: 0, size: 30 }
    def self.all(params = {})
      raw_response = RestClient.get('/v1/clients', { params: })
      ClientPagedResponse.new(raw_response, {})
    end

    # https://docs.developer.tazworks.com/#da4edfa1-a2b0-4015-a622-23998864b14c
    def self.descendents(_clientGuid)
      raise 'Unimplemented'
    end

    # https://docs.developer.tazworks.com/#31f1c04e-6cba-4e6d-9499-23d5dafe16f8
    def self.ancestors(_clientGuid)
      raise 'Unimplemented'
    end

    ## consider splitting these up into mixins if they get too big

    # Orders/Applicants

    def applicants(params = {})
      Applicant.all(clientGuid, params)
    end

    def orders(params = {})
      Order.all(clientGuid, params)
    end

    def client_products(params = {})
      ClientProduct.all(clientGuid, params)
    end

    def create_applicant(params)
      Tazworks::Applicant.create(clientGuid, params)
    end

    # https://docs.developer.tazworks.com/#097f5a2a-85f5-4bb7-b208-facc7e66b98f
    def find_applicant(applicantGuid)
      Tazworks::Applicant.find(ids: { clientGuid:, applicantGuid: })
    end

    def submit_order(params)
      Order.create(clientGuid, params)
    end

    def ancestors
      Client.ancestors(clientGuid)
    end

    def descendents(clientGuid)
      Client.descendents(clientGuid)
    end
  end
end
