# frozen_string_literal: true

module Tazworks
  # Tazworks Set Configuration
  class Config
    DEFAULT_SANDBOX_HOST = 'https://api-sandbox.instascreen.net'
    DEFAULT_PRODUCTION_HOST = 'https://api.instascreen.net'
    DEFAULT_PORT = 443

    attr_accessor :api_key, :sandbox, :host, :port

    def base_uri
      host = @host
      host ||= @sandbox ? DEFAULT_SANDBOX_HOST : DEFAULT_PRODUCTION_HOST
      URI.parse("#{host}:#{@port || DEFAULT_PORT}")
    end
  end
end
