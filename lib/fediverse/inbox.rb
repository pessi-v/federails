require 'fediverse/request'

module Fediverse
  class Inbox
    class << self
      def dispatch_request(payload)
        case payload['type']
        when 'Create'
          handle_create_request payload
        when 'Follow'
          handle_create_follow_request payload
        when 'Accept'
          handle_accept_request payload
        when 'Undo'
          handle_undo_request payload
        else
          # FIXME: Fails silently
          # raise NotImplementedError
          Rails.logger.debug { "Unhandled activity type: #{payload['type']}" }
        end
      end

      private

      def handle_create_request(payload)
        activity = Request.get(payload['object'])
        case activity['type']
        when 'Follow'
          handle_create_follow_request activity
        when 'Note'
          handle_create_note activity
        end
      end

      def handle_create_follow_request(activity)
        actor        = Federails::Actor.find_or_create_by_object activity['actor']
        target_actor = Federails::Actor.find_or_create_by_object activity['object']

        Federails::Following.create! actor: actor, target_actor: target_actor, federated_url: activity['id']
      end

      def handle_create_note(activity)
        actor = Federails::Actor.find_or_create_by_object activity['attributedTo']
        Note.create! actor: actor, content: activity['content'], federated_url: activity['id']
      end

      def handle_accept_request(payload)
        activity = Request.get(payload['object'])
        raise "Can't accept things that are not Follow" unless activity['type'] == 'Follow'

        actor        = Federails::Actor.find_or_create_by_object activity['actor']
        target_actor = Federails::Actor.find_or_create_by_object activity['object']
        raise 'Follow not accepted by target actor but by someone else' if payload['actor'] != target_actor.federated_url

        follow = Federails::Following.find_by actor: actor, target_actor: target_actor
        follow.accept!
      end

      def handle_undo_request(payload)
        activity = payload['object']
        raise "Can't undo things that are not Follow" unless activity['type'] == 'Follow'

        actor        = Federails::Actor.find_or_create_by_object activity['actor']
        target_actor = Federails::Actor.find_or_create_by_object activity['object']

        follow = Federails::Following.find_by actor: actor, target_actor: target_actor
        follow&.destroy
      end
    end
  end
end
