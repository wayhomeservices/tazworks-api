# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'vcr'
require 'tazworks'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data('<BEARER_TOKEN>') do |interaction|
    auths = interaction.request.headers['Authorization'].first
    if (match = auths.match(/^Bearer\s+([^,\s]+)/))
      match.captures.first
    end
  end
end

Tazworks.configure do |c|
  c.api_key = ENV.fetch('TAZAPI_KEY', 'mock-key')
  c.sandbox = true
end

TEST_DEFAULT_CLIENT_GUID = '34f3264e-138a-47d1-987c-f2673a569b96'
TEST_DEFAULT_APPLICANT_GUID = 'b19ef9aa-e920-4d42-837d-6e0f457ed99e'
TEST_DEFAULT_CLIENT_PRODUCT_GUID = '52cc80b3-bb55-4d81-9fa1-6c0f3c7a57e0'
TEST_DEFAULT_ORDER_GUID = 'f0ec9cf8-a4ad-4e50-9d1f-8871e3db5a26'
