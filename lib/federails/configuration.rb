module Federails
  # rubocop:disable Style/ClassVars
  module Configuration
    mattr_accessor :force_ssl
    @@force_ssl = nil

    mattr_accessor :site_host
    @@site_host = nil

    mattr_accessor :site_port
    @@site_port = nil

    mattr_accessor :user_class
    @@user_class = '::User'

    mattr_accessor :routes_path
    @@routes_path = :federation

    mattr_accessor :user_profile_url_method
    @@user_profile_url_method = :user_url

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
  end
  # rubocop:enable Style/ClassVars
end
