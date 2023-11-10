require 'rails_helper'

module Federails
  RSpec.describe FollowingsController, type: :routing do
    describe 'routing' do
      it 'routes to #show' do
        expect(get: '/federation/actors/1/followings/2').to route_to('federails/followings#show', actor_id: '1', id: '2')
      end
    end
  end
end
