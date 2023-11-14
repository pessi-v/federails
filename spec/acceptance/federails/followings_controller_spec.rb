require 'rails_helper'

RSpec.describe Federails::FollowingsController, type: :acceptance do
  resource 'Federation/Followings', 'Followings management'

  entity :following,
         '@context': { type: :string, description: 'JSON-LD contexts' },
         id:         { type: :string, description: 'Federated id for this following' },
         type:       { type: :string, description: 'Object type. Should be "Follow"' },
         actor:      { type: :string, description: 'Federated ID of the creator' },
         object:     { type: :string, description: 'Federated ID of the followed actor' }

  parameters :following_path_params,
             actor_id: { type: :integer, description: 'Actor identifier. Not the JSON-LD identifier' },
             id:       { type: :integer, description: 'Following identifier' }

  let(:user) { FactoryBot.create :user }
  let(:following) do
    target_actor = FactoryBot.create(:user).actor
    FactoryBot.create :following, actor: user.actor, target_actor: target_actor
  end

  on_get '/federation/actors/:actor_id/followings/:id', 'Display a following' do
    for_code 200, expect_one: :following do |url|
      test_response_of url, path_params: { actor_id: following.actor_id, id: following.id }
    end

    for_code 404, expect_one: :error do |url|
      test_response_of url, path_params: { actor_id: following.actor_id, id: 0 }
    end
  end
end
