module Fediverse
  class Request
    BASE_HEADERS = {
      'Content-Type' => 'application/json',
      'Accept'       => 'application/json',
    }.freeze

    def initialize(id)
      @id = id
    end

    def get
      Rails.logger.debug { "GET #{@id}" }
      @response = Faraday.get(@id, nil, BASE_HEADERS)
      response_to_json
    end

    class << self
      def get(id)
        new(id).get
      end
    end

    private

    def response_to_json
      begin
        body = JSON.parse @response.body
      rescue JSON::ParserError
        return
      end

      JSON::LD::API.compact body, body['@context']
    end
  end
end
