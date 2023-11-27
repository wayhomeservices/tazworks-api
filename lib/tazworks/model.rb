# frozen_string_literal: true

module Tazworks
  # Base model
  class Model
    attr_accessor :attributes, :ids
    attr_reader :attributes_loaded

    def self.find(ids)
      initialize_from_response(ids, get(ids))
    end

    def self.get(_ids)
      raise 'Must Implement Me in the Concrete Class'
    end

    def load_attributes
      response = self.class.get(ids)
      @attributes = JSON.parse(response.body, { symbolize_names: true })
      @attributes_loaded = true
    end

    def initialize(ids:, attributes: {}, attributes_loaded: false)
      @attributes = attributes
      @ids = ids
      @attributes_loaded = attributes_loaded
    end

    def self.initialize_from_response(ids, response)
      json_response = JSON.parse(response.body, { symbolize_names: true })
      new(ids:, attributes: json_response, attributes_loaded: true)
    end

    def attributes_loaded?
      !!@attributes_loaded
    end

    def clientGuid
      @ids[:clientGuid]
    end

    # ensures attributes are loaded from the server
    def loaded_attributes
      load_attributes unless attributes_loaded?
      @attributes
    end

    def reload
      load_attributes
    end
  end
end
