# frozen_string_literal: true

require 'rest-client'
require 'json'

module Tazworks
  # Wrapper for rest-client
  class RestClient
    def self.url(uri)
      "#{Tazworks.config.base_uri}#{uri}"
    end

    def self.merged_headers(headers)
      raise ArgumentError, 'api_key is not set in Tazworks configuration' unless Tazworks.config.api_key

      default_headers = {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{Tazworks.config.api_key}"
      }
      default_headers.merge(headers)
    end

    def self.get(uri, headers = {})
      ::RestClient.get(url(uri), merged_headers(headers))
    end

    def self.post(uri, payload, headers = {})
      ::RestClient.post(url(uri), payload.to_json, merged_headers(headers))
    end
  end
end
