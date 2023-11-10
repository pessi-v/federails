require 'rails_helper'

module Federails
  RSpec.describe WebFingerController, type: :routing do
    describe 'routing' do
      it 'routes to #find' do
        expect(get: '/.well-known/webfinger?resource=someone@here.com').to route_to('federails/web_finger#find', resource: 'someone@here.com')
      end

      it 'routes to #host_meta' do
        expect(get: '/.well-known/host-meta').to route_to('federails/web_finger#host_meta')
      end
    end
  end
end
