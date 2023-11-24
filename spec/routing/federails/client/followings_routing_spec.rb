require 'rails_helper'

module Federails
  module Client
    RSpec.describe FollowingsController, type: :routing do
      describe 'routing' do
        it 'routes to #follow' do
          expect(post: '/app/followings/follow').to route_to('federails/client/followings#follow')
        end

        it 'routes to #accept' do
          expect(put: '/app/followings/1/accept').to route_to('federails/client/followings#accept', id: '1')
        end

        it 'routes to #create' do
          expect(post: '/app/followings').to route_to('federails/client/followings#create')
        end

        it 'routes to #destroy' do
          expect(delete: '/app/followings/1').to route_to('federails/client/followings#destroy', id: '1')
        end
      end
    end
  end
end
