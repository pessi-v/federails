module Federails
  module User
    extend ActiveSupport::Concern

    included do
      has_one :actor, class_name: 'Federails::Actor', inverse_of: :user, dependent: :destroy

      after_create :create_actor

      private

      def create_actor
        Federails::Actor.create! user: self
      end
    end
  end
end
