require 'rails_helper'
require 'pundit/rspec'

RSpec.describe Federails::Client::ActivityPolicy, type: :policy do
  let(:signed_in_user) { FactoryBot.create :user }
  let(:scope) { Federails::Client::ActivityPolicy::Scope.new(nil, Federails::Activity).resolve }

  permissions '.scope' do
    it 'returns all the activities' do
      FactoryBot.create_list :following, 2, target_actor: signed_in_user.actor

      expect(scope.count).to eq 2
    end
  end

  permissions :index? do
    context 'when unauthenticated' do
      it 'grants access' do
        expect(described_class).to permit(nil, Federails::Activity)
      end
    end

    context 'when authenticated' do
      it 'grants access' do
        expect(described_class).to permit(signed_in_user, Federails::Activity)
      end
    end
  end
end
