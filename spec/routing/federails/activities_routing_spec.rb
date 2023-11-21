require 'rails_helper'

module Federails
  RSpec.describe ActivitiesController, type: :routing do
    describe 'routing' do
      it 'routes to #outbox' do
        expect(get: '/federation/actors/1/outbox').to route_to('federails/activities#outbox', actor_id: '1')
      end

      it 'routes to #show' do
        expect(get: '/federation/actors/1/activities/2').to route_to('federails/activities#show', actor_id: '1', id: '2')
      end

      it 'routes to #create' do
        expect(post: '/federation/actors/1/inbox').to route_to('federails/activities#create', actor_id: '1')
      end
    end
  end
end
