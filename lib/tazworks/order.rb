# frozen_string_literal: true

require 'json'

module Tazworks
  # Tazworks Orders Model
  class Order < Model
    # https://docs.developer.tazworks.com/#cc17be7c-6b55-4329-991d-6414fad702de
    def self.get(ids)
      RestClient.get("/v1/clients/#{ids[:clientGuid]}/orders/#{ids[:orderGuid]}")
    end

    # https://docs.developer.tazworks.com/#7f41facc-fa45-4d09-a25a-9943d00bfb57
    def self.all(clientGuid, params = {})
      raw_response = RestClient.get("/v1/clients/#{clientGuid}/orders", { params: })
      OrderPagedResponse.new(raw_response, { clientGuid: })
    end

    # https://docs.developer.tazworks.com/#494c3491-bb92-41a9-bee8-c1601fe957aa
    def self.create(clientGuid, params)
      required_params = %w[applicantGuid clientProductGuid]
      required_params.each do |rp|
        raise ArgumentError, "#{rp} is missing in params hash." unless params.key?(rp.to_sym)
      end

      response = RestClient.post("/v1/clients/#{clientGuid}/orders", params)

      order = Order.initialize_from_response({ clientGuid: }, response)
      order.ids[:orderGuid] = order.attributes[:orderGuid]
      order
    end

    # https://docs.developer.tazworks.com/#16c2bff6-501c-432b-a89d-19141f277fc6
    def order_status
      response = RestClient.get("/v1/clients/#{clientGuid}/orders/#{orderGuid}/status")
      JSON.parse(response.body)
    end

    # https://docs.developer.tazworks.com/#149663fc-2923-4836-a3c7-1dc62a293fba
    def results_as_pdf
      begin
        response = RestClient.get("/v1/clients/#{clientGuid}/orders/#{orderGuid}/resultsAsPdf")
      rescue ::RestClient::BadRequest => e
        raise Error, e.response.body
      end
      json_parsed = JSON.parse(response.body, { symbolize_names: true })
      json_parsed[:resultsUrl]
    end

    def orderGuid
      @ids[:orderGuid]
    end

    def quickappApplicantLink
      loaded_attributes[:quickappApplicantLink]
    end
  end
end
