require 'rspec/rfc_helper'

RSpec.configure do |config|
  config.before(:suite) do
    RSpec::RfcHelper.start_from_file 'specs.yaml'
  end

  config.after(:suite) do
    RSpec::RfcHelper.save_markdown_report 'report.md'
  end

  config.after do |example|
    RSpec::RfcHelper.add_example(example)
  end
end
