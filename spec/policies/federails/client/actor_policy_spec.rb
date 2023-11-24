require 'rails_helper'
require 'pundit/rspec'

RSpec.describe Federails::Client::ActorPolicy, type: :policy do
  let(:signed_in_user) { FactoryBot.create :user }
  let(:scope) { Federails::Client::ActorPolicy::Scope.new(nil, Federails::Actor).resolve }

  permissions '.scope' do
    it 'returns all the actors' do
      FactoryBot.create_list :user, 2
      FactoryBot.create :distant_actor # Should be ignored

      # Plus the one created in the "before :suite" in rails helper
      expect(scope.count).to eq 3
    end
  end

  permissions :index? do
    context 'when unauthenticated' do
      it 'grants access' do
        expect(described_class).to permit(nil, Federails::Actor)
      end
    end

    context 'when authenticated' do
      it 'grants access' do
        expect(described_class).to permit(signed_in_user, Federails::Actor)
      end
    end
  end

  permissions :show? do
    context 'when unauthenticated' do
      it 'grants access' do
        expect(described_class).to permit(nil, signed_in_user.actor)
      end
    end

    context 'when authenticated' do
      it 'grants access' do
        expect(described_class).to permit(signed_in_user, signed_in_user.actor)
      end
    end
  end
end
