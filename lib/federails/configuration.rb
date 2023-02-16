module Federails
  # rubocop:disable Style/ClassVars
  module Configuration
    mattr_accessor :force_ssl
    @@force_ssl = nil

    mattr_accessor :site_host
    @@site_host = nil

    mattr_accessor :site_port
    @@site_port = nil
  end
  # rubocop:enable Style/ClassVars
end
