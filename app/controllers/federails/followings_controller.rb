module Federation
  class FollowingsController < FederationApplicationController
    before_action :set_following, only: [:show]

    # GET /federation/actors/1/followings/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_following
      @following = Following.find_by!(actor_id: params[:actor_id], id: params[:id])
      authorize @following
    end
  end
end
