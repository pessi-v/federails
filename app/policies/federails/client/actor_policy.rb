module Federails
  module Client
    class ActorPolicy < Federails::FederailsPolicy
      def lookup?
        true
      end

      class Scope < Scope
        def resolve
          scope.local
        end
      end
    end
  end
end
