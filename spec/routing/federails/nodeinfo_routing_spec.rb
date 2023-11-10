require 'rails_helper'

module Federails
  RSpec.describe NodeinfoController, type: :routing do
    describe 'routing' do
      it 'routes to #index' do
        expect(get: '/.well-known/nodeinfo').to route_to('federails/nodeinfo#index')
      end

      it 'routes to #show' do
        expect(get: '/nodeinfo/2.0').to route_to('federails/nodeinfo#show')
      end
    end
  end
end
