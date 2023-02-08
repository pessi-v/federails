module Federails
  class ActorsController < ApplicationController
    before_action :set_federation_actor, only: [:show, :followers, :following]

    # GET /federation/actors/1
    # GET /federation/actors/1.json
    def show; end

    def followers
      @actors = @actor.followers.order(created_at: :desc)
      followings_queries
    end

    def following
      @actors = @actor.follows.order(created_at: :desc)
      followings_queries
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_federation_actor
      @actor = Actor.find(params[:id])
      authorize @actor
    end

    def followings_queries
      @total_actors = @actors.count
      @actors       = @actors.page(params[:page])
    end
  end
end
