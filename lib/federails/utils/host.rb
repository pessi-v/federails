module Federails
  module Utils
    class Host
      class << self
        COMMON_PORTS = [80, 443].freeze

        def localhost
          uri = URI.parse Federails.configuration.site_host
          host_and_port uri.host, Federails.configuration.site_port
        end

        def local_url?(url)
          uri = URI.parse url
          host = host_and_port uri.host, uri.port

          localhost == host
        end

        def local_route(url)
          return nil unless local_url? url

          Rails.application.routes.recognize_path(url)
        rescue ActionController::RoutingError
          nil
        end

        private

        def host_and_port(host, port)
          port_string = if port.present? && COMMON_PORTS.exclude?(port)
                          ":#{port}"
                        else
                          ''
                        end

          "#{host}#{port_string}"
        end
      end
    end
  end
end
