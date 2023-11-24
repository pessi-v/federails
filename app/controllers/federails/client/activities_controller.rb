module Federails
  module Client
    class ActivitiesController < Federails::ApplicationController
      before_action :authenticate_user!, only: [:feed]
      # layout 'layouts/application'

      # GET /app/activities
      # GET /app/activities.json
      def index
        @activities = policy_scope(Federails::Activity, policy_scope_class: Federails::Client::ActivityPolicy::Scope).all
        @activities = @activities.where actor_id: params[:actor_id] if params[:actor_id]
      end

      # GET /app/feed
      # GET /app/feed.json
      def feed
        @activities = Activity.feed_for(current_user.actor)
      end
    end
  end
end
