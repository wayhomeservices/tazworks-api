# frozen_string_literal: true

require_relative 'tazworks/version'
require_relative 'tazworks/config'
require_relative 'tazworks/model'
require_relative 'tazworks/rest_client'
require_relative 'tazworks/client'
require_relative 'tazworks/client_product'
require_relative 'tazworks/applicant'
require_relative 'tazworks/order'

require_relative 'tazworks/paged_response'
require_relative 'tazworks/client_paged_response'
require_relative 'tazworks/client_product_paged_response'
require_relative 'tazworks/applicant_paged_response'
require_relative 'tazworks/order_paged_response'

# Tazworks Configuration
module Tazworks
  def configure(&)
    config.tap(&)
  end

  def config
    @config ||= Config.new
  end

  module_function :configure, :config

  class Error < StandardError; end
end
