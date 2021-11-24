# frozen_string_literal: true

require_relative '../config/boot'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/tmp/bundle'
end

require 'pry'

RSpec.configure do |config|
  config.order = :random

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |c|
    c.syntax = :expect
    c.verify_doubled_constant_names = true
    c.verify_partial_doubles = true
  end
end

Dir.glob(File.expand_path('supports/**/*.rb', __dir__)).sort.each do |path|
  require path
end
