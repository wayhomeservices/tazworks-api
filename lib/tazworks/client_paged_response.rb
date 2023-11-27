# frozen_string_literal: true

module Tazworks
  # Handles pagination for Client Responses such as GET All Clients
  class ClientPagedResponse < PagedResponse
    def self.base_class
      Client
    end

    def clients
      response_to_models
    end

    def map_individual_object_ids(ids, attributes)
      ids[:clientGuid] = attributes[:clientGuid]
      ids
    end
  end
end
