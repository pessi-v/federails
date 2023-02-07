module Federails
  class Following < ApplicationRecord
    include Routeable

    enum status: { pending: 0, accepted: 1 }

    validates :target_actor_id, uniqueness: { scope: [:actor_id, :target_actor_id] }

    belongs_to :actor
    belongs_to :target_actor, class_name: 'Federails::Actor'
    # FIXME: Handle this with something like undelete
    has_many :activities, as: :entity, dependent: :destroy

    after_create :create_activity
    after_destroy :destroy_activity

    scope :with_actor, ->(actor) { where(actor_id: actor.id).or(where(target_actor_id: actor.id)) }

    def federated_url
      attributes['federated_url'].presence || federation_actor_following_url(actor_id: actor_id, id: id)
    end

    def accept!
      update! status: :accepted
      Activity.create! actor: target_actor, action: 'Accept', entity: self
    end

    class << self
      def new_from_account(account, actor:)
        target_actor = Actor.find_or_create_by_account account
        new actor: actor, target_actor: target_actor
      end
    end

    private

    def create_activity
      Activity.create! actor: actor, action: 'Create', entity: self
    end

    def destroy_activity
      Activity.create! actor: actor, action: 'Undo', entity: self
    end
  end
end
