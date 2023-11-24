require 'rails_helper'

module Federails
  module Client
    RSpec.describe ActorsController, type: :routing do
      describe 'routing' do
        it 'routes to #index' do
          expect(get: '/app/actors').to route_to('federails/client/actors#index')
        end

        it 'routes to #show' do
          expect(get: '/app/actors/1').to route_to('federails/client/actors#show', id: '1')
        end

        it 'routes to #lookup' do
          expect(get: '/app/actors/lookup?account=bob').to route_to('federails/client/actors#lookup', account: 'bob')
        end
      end
    end
  end
end
