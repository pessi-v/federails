require 'rails_helper'

RSpec.describe Federails::ActorPolicy, type: :policy do
  let(:signed_in_user) { FactoryBot.create :user, :confirmed }
  let(:scope) { Pundit.policy_scope!(nil, [:federation, Actor]) }

  permissions '.scope' do
    it 'returns all the confirmed users' do
      FactoryBot.create :user
      FactoryBot.create :user, :confirmed

      # Plus the one created in the "before :suite" in rails helper
      expect(scope.all.count).to eq 3
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
