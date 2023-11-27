# frozen_string_literal: true

module Tazworks
  # Handles pagination for ClientProduct responses such as Get All ClientProducts
  class ClientProductPagedResponse < PagedResponse
    def self.base_class
      ClientProduct
    end

    def client_products
      response_to_models
    end

    def map_individual_object_ids(ids, attributes)
      ids[:clientProductGuid] = attributes[:clientProductGuid]
      ids
    end
  end
end
