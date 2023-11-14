require 'rspec_rails_api'

RSpec.configure do |config|
  RSpec::Rails::DIRECTORY_MAPPINGS[:acceptance] = %w[spec acceptance]
  config.include RSpec::Rails::Api::DSL::Example
  config.include RSpec::Rails::RequestExampleGroup, type: :acceptance
end
