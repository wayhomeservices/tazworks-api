# frozen_string_literal: true

module Tazworks
  # Tazworks Clients Model
  class ClientProduct < Model
    # https://docs.developer.tazworks.com/#bc9ed960-33e3-4eed-9f25-7b052b0d4e6f
    # tazapi defaults to params { page: 0, size: 30 }
    def self.all(clientGuid, params = {})
      raw_response = RestClient.get("/v1/clients/#{clientGuid}/products", { params: })
      ClientProductPagedResponse.new(raw_response, { clientGuid: })
    end

    # TODO: WARNING - this method is untested; maintainer does not a key that is authorized to use this endpoint
    def self.get(ids)
      RestClient.get("/v1/clients/#{ids[:clientGuid]}/products/#{ids[:clientProductGuid]}")
    end

    def clientProductGuid
      @ids[:clientProductGuid]
    end
  end
end
