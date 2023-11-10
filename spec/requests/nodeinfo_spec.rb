require 'rails_helper'

RSpec.describe '/nodeinfo', type: :request do
  describe 'GET /.well-known/nodeinfo' do
    it 'renders a successful response' do
      get node_info_url
      expect(response).to be_successful
    end
  end

  describe 'GET /nodeinfo/2.0' do
    it 'renders a successful response' do
      get show_node_info_url
      expect(response).to be_successful
    end
  end
end
