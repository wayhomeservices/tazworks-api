# frozen_string_literal: true

module Tazworks
  # Handles pagination for Order responses such as GET All Orders
  class OrderPagedResponse < PagedResponse
    def self.base_class
      Order
    end

    def orders
      response_to_models
    end

    def map_individual_object_ids(ids, attributes)
      ids[:orderGuid] = attributes[:orderGuid]
      ids
    end
  end
end
