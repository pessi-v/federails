require 'federails/utils/host'
require 'fediverse/webfinger'

module Federails
  class Actor < ApplicationRecord # rubocop:disable Metrics/ClassLength
    validates :federated_url, presence: { unless: :user_id }, uniqueness: { unless: :user_id }
    validates :username, presence: { unless: :user_id }
    validates :server, presence: { unless: :user_id }
    validates :inbox_url, presence: { unless: :user_id }
    validates :outbox_url, presence: { unless: :user_id }
    validates :followers_url, presence: { unless: :user_id }
    validates :followings_url, presence: { unless: :user_id }
    validates :profile_url, presence: { unless: :user_id }
    validates :user_id, uniqueness: true, if: :local?

    belongs_to :user, class_name: Federails.configuration.user_class, optional: true # rubocop:disable Rails/ReflectionClassName
    # FIXME: Handle this with something like undelete
    has_many :activities, dependent: :destroy
    has_many :following_followers, class_name: 'Following', foreign_key: :target_actor_id, dependent: :destroy, inverse_of: :target_actor
    has_many :following_follows, class_name: 'Following', dependent: :destroy, inverse_of: :actor
    has_many :followers, source: :actor, through: :following_followers
    has_many :follows, source: :target_actor, through: :following_follows

    scope :local, -> { where.not(user_id: nil) }

    def local?
      user_id.present?
    end

    def federated_url
      local? ? Federails::Engine.routes.url_helpers.actor_url(self) : attributes['federated_url'].presence
    end

    def username
      return attributes['username'] unless local?

      user.send(Federails.configuration.user_username_field).to_s
    end

    def name
      value = local? ? user.send(Federails.configuration.user_name_field).to_s : attributes[:name]

      value || username
    end

    def server
      local? ? Utils::Host.localhost : attributes['server']
    end

    def inbox_url
      local? ? Federails::Engine.routes.url_helpers.actor_inbox_url(self) : attributes['inbox_url']
    end

    def outbox_url
      local? ? Federails::Engine.routes.url_helpers.actor_outbox_url(self) : attributes['outbox_url']
    end

    def followers_url
      local? ? Federails::Engine.routes.url_helpers.followers_actor_url(self) : attributes['followers_url']
    end

    def followings_url
      local? ? Federails::Engine.routes.url_helpers.following_actor_url(self) : attributes['followings_url']
    end

    def profile_url
      return attributes['profile_url'].presence unless local?

      method = Federails.configuration.user_profile_url_method
      return Federails::Engine.routes.url_helpers.actor_url self unless method

      Rails.application.routes.send method, user
    end

    def at_address
      "#{username}@#{server}"
    end

    def short_at_address
      local? ? "@#{username}" : at_address
    end

    def follows?(actor)
      list = following_follows.where target_actor: actor
      return list.first if list.count == 1

      false
    end

    class << self
      def find_by_account(account)
        parts = Fediverse::Webfinger.split_account account

        if Fediverse::Webfinger.local_user? parts
          actor = Federails.configuration.user_model.find_by!({ Federails.configuration.user_username_field => parts[:username] }).actor
        else
          actor = find_by username: parts[:username], server: parts[:domain]
          actor ||= Fediverse::Webfinger.fetch_actor(parts[:username], parts[:domain])
        end

        actor
      end

      def find_by_federation_url(federated_url)
        local_route = Utils::Host.local_route federated_url
        return find local_route[:id] if local_route && local_route[:controller] == 'federails/actors' && local_route[:action] == 'show'

        actor = find_by federated_url: federated_url
        return actor if actor

        Fediverse::Webfinger.fetch_actor_url(federated_url)
      end

      def find_or_create_by_account(account)
        actor = find_by_account account
        # Create/update distant actors
        actor.save! unless actor.local?

        actor
      end

      def find_or_create_by_federation_url(url)
        actor = find_by_federation_url url
        # Create/update distant actors
        actor.save! unless actor.local?

        actor
      end

      # Find or create actor from a given actor hash or actor id (actor's URL)
      def find_or_create_by_object(object)
        case object
        when String
          find_or_create_by_federation_url object
        when Hash
          find_or_create_by_federation_url object['id']
        else
          raise "Unsupported object type for actor (#{object.class})"
        end
      end
    end
  end
end
