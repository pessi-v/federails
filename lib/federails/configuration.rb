module Federails
  # rubocop:disable Style/ClassVars
  module Configuration
    # Application name, used in well-known and nodeinfo endpoints
    mattr_accessor :app_name
    @@app_name = nil

    # Application version, used in well-known and nodeinfo endpoints
    mattr_accessor :app_version
    @@app_version = nil

    # Force https urls in various rendered content (currently in webfinger views)
    mattr_accessor :force_ssl
    @@force_ssl = nil

    # Site hostname
    mattr_reader :site_host
    @@site_host = nil

    # Site port
    mattr_reader :site_port
    @@site_port = nil

    # User model
    mattr_accessor :user_class
    @@user_class = '::User'

    # Route path for the federation URLS (to "Federails::Server::*" controllers)
    mattr_accessor :routes_path
    @@routes_path = :federation

    # Method to use for links to user profiles.
    mattr_accessor :user_profile_url_method
    @@user_profile_url_method = nil

    # Attribute in the user model to use as the user's name
    #
    # It only have sense if you have a separate username attribute
    mattr_accessor :user_name_field
    @@user_name_field = nil

    # Attribute in the user model to use as the username for local actors
    mattr_accessor :user_username_field
    @@user_username_field = :id

    ##
    # @return [String] Table used for user model
    def self.user_table
      user_model.table_name
    end

    ##
    # @return [ActiveRecord::Base]
    def self.user_model
      raise 'User class is not defined' unless @@user_class

      @@user_class.constantize
    end

    def self.site_host=(value)
      @@site_host = value
      Federails::Engine.routes.default_url_options[:host] = value
    end

    def self.site_port=(value)
      @@site_port = value
      Federails::Engine.routes.default_url_options[:port] = value
    end
  end
  # rubocop:enable Style/ClassVars
end
