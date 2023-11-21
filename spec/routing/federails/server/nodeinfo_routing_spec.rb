require 'rails_helper'

module Federails
  module Server
    RSpec.describe NodeinfoController, type: :routing do
      describe 'routing' do
        it 'routes to #index' do
          expect(get: '/.well-known/nodeinfo').to route_to('federails/server/nodeinfo#index')
        end

        it 'routes to #show' do
          expect(get: '/nodeinfo/2.0').to route_to('federails/server/nodeinfo#show')
        end
      end
    end
  end
end
