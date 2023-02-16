module Federails
  # rubocop:disable Style/ClassVars
  module Configuration
    mattr_accessor :force_ssl
    @@force_ssl = nil

    mattr_reader :site_host
    @@site_host = nil

    mattr_reader :site_port
    @@site_port = nil

    mattr_accessor :user_class
    @@user_class = '::User'

    mattr_accessor :routes_path
    @@routes_path = :federation

    mattr_accessor :user_profile_url_method
    @@user_profile_url_method = :user_url

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
