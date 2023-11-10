require 'rails_helper'

RSpec.describe '/well-known', type: :request do
  describe 'GET /.well-known/webfinger' do
    it 'renders a successful response' do
      FactoryBot.create :user, username: 'roberto'
      get webfinger_url, params: { resource: 'acct:roberto@localhost' }
      expect(response).to be_successful
    end
  end

  describe 'GET /.well-known/host-meta' do
    it 'renders a successful response' do
      get host_meta_url
      expect(response).to be_successful
    end
  end

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
