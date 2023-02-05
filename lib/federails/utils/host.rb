module Utils
  class Host
    class << self
      def localhost
        uri  = URI.parse Rails.application.default_url_options[:host]
        port = Rails.application.default_url_options[:port] || nil

        localhost = uri.host
        localhost += ":#{port}" if port.present? && [80, 443].exclude?(port)

        localhost
      end

      def local_url?(url)
        uri = URI.parse url
        host = uri.host
        host += ":#{uri.port}" if uri.port && [80, 443].exclude?(uri.port)

        localhost == host
      end

      def local_route(url)
        return nil unless local_url? url

        Rails.application.routes.recognize_path(url)
      rescue ActionController::RoutingError
        nil
      end
    end
  end
end
