require 'federails/version'
require 'federails/engine'

module Federails
  # Make factories available
  config.factory_bot.definition_file_paths += [File.expand_path('spec/factories', __dir__)] if defined?(FactoryBotRails)
end
