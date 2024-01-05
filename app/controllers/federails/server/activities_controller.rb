require 'fediverse/inbox'

module Federails
  module Server
    class ActivitiesController < ServerController
      before_action :set_activity, only: [:show]

      # GET /federation/activities
      # GET /federation/actors/1/outbox.json
      def outbox
        @actor            = Actor.find(params[:actor_id])
        @activities       = policy_scope(Federails::Activity, policy_scope_class: Federails::Server::ActivityPolicy::Scope).where(actor: @actor).order(created_at: :desc)
        @total_activities = @activities.count
        @activities       = @activities.page(params[:page])
      end

      # GET /federation/actors/1/activities/1.json
      def show; end

      # POST /federation/actors/1/inbox
      def create
        payload = payload_from_params
        return render json: {}, status: :unprocessable_entity unless payload

        if Fediverse::Inbox.dispatch_request(payload)
          render json: {}, status: :created
        else
          render json: {}, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_activity
        @activity = Activity.find_by!(actor_id: params[:actor_id], id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def activity_params
        params.fetch(:activity, {})
      end

      def payload_from_params
        payload_string = request.body.read
        request.body.rewind if request.body.respond_to? :rewind

        begin
          payload = JSON.parse(payload_string)
        rescue JSON::ParserError
          return
        end

        hash = JSON::LD::API.compact payload, payload['@context']
        validate_payload hash
      end

      def validate_payload(hash)
        return unless hash['@context'] && hash['id'] && hash['type'] && hash['actor'] && hash['object']

        hash
      end
    end
  end
end
