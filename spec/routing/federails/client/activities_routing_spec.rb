require 'rails_helper'

module Federails
  module Client
    RSpec.describe ActivitiesController, type: :routing do
      describe 'routing' do
        it 'routes to #index' do
          expect(get: '/app/activities').to route_to('federails/client/activities#index')
        end

        it 'routes to #index via actors' do
          expect(get: '/app/actors/1/activities').to route_to('federails/client/activities#index', actor_id: '1')
        end

        it 'routes to #feed' do
          expect(get: '/app/feed').to route_to('federails/client/activities#feed')
        end
      end
    end
  end
end
