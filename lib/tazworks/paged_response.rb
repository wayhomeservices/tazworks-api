# frozen_string_literal: true

require 'json'

module Tazworks
  # Paged Response Model to Handle Paginated Results
  class PagedResponse
    attr_accessor :raw_response, :ids

    def initialize(response, ids)
      @ids = ids
      @raw_response = response
    end

    def self.base_class
      raise 'Must Implement Me in the Concrete Class'
    end

    def raw_json_response
      @raw_response.body
    end

    def response_to_models
      return @collection if @collection

      json_response = JSON.parse(raw_response.body, { symbolize_names: true })
      @collection = json_response.map do |json_object|
        self.class.base_class.new(ids: map_individual_object_ids(@ids, json_object), attributes: json_object,
                                  attributes_loaded: true)
      end
    end

    # this method is utilized to create proper ids for individual objects from the attributes
    def map_individual_object_ids(_ids, _attributes)
      raise 'Must Implement Me in the Concrete Class'
    end

    def next
      # might be nice to have a way that automatically calls the next page with the parameters already known here.
      raise 'Unimplemented'
    end

    def last
      # might be nice to have a way that automatically calls the next page with the parameters already known here.
      raise 'Unimplemented'
    end

    def response_links
      @raw_response.headers[:link]&.split(',')
    end

    def next_page
      return nil unless response_links

      next_link = response_links.grep(/rel="next"/).first
      return nil if next_link.nil?

      # scary regex to pull the parameter off the url.
      next_link[/.*page=(\d+)&.*/, 1].to_i
    end

    # pages seem to start with 0, so defaulting to 0 when there are only "1" page.
    def total_number_of_pages
      return 0 unless response_links

      last_link = response_links.grep(/rel="last"/).first
      return 0 if last_link.nil?

      # scary regex to pull the parameter off the url.
      last_link[/.*page=(\d+)&.*/, 1].to_i
    end
  end
end
