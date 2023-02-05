module Federails
  class Engine < ::Rails::Engine
    isolate_namespace Federails

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
