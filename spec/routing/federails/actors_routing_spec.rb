require 'rails_helper'

module Federails
  RSpec.describe ActorsController, type: :routing do
    describe 'routing' do
      it 'routes to #show' do
        expect(get: '/federation/actors/1').to route_to('federails/actors#show', id: '1')
      end

      it 'routes to #followers' do
        expect(get: '/federation/actors/1/followers').to route_to('federails/actors#followers', id: '1')
      end

      it 'routes to #following' do
        expect(get: '/federation/actors/1/following').to route_to('federails/actors#following', id: '1')
      end
    end
  end
end
