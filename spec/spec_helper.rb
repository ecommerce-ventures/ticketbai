# frozen_string_literal: true
require 'rspec'
require 'webmock/rspec'

Dir["#{File.expand_path("../", __dir__)}/spec/support/**/*.rb"].each.each { |f| require f }

RSpec.configure do |config|
  config.include TicketbaiConfig

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
