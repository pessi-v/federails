module Federails
  module Server
    class NodeinfoController < ServerController
      def index
        render formats: [:json]
      end

      def show
        render formats: [:json]
      end
    end
  end
end
