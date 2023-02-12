require 'federails/version'
require 'federails/engine'
require 'federails/configuration'

# rubocop:disable Style/ClassVars
module Federails
  mattr_reader :configuration
  @@configuration = Configuration

  # Make factories available
  config.factory_bot.definition_file_paths += [File.expand_path('spec/factories', __dir__)] if defined?(FactoryBotRails)

  def self.configure
    yield @@configuration
  end

  def self.config_from(name)
    config = Rails.application.config_for name
    [
      :force_ssl,
      :site_host,
      :site_port,
      :user_class,
      :routes_path,
      :user_profile_url_method,
    ].each { |key| Configuration.send "#{key}=", config[key] }
  end
end
# rubocop:enable Style/ClassVars
