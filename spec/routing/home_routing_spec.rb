require 'rails_helper'

RSpec.describe HomeController, type: :routing do
  describe 'routing' do
    it 'routes to #home' do
      expect(get: '/').to route_to('home#home')
    end
  end
end
