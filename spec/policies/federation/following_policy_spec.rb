require 'rails_helper'

RSpec.describe Federails::FollowingPolicy, type: :policy do
  let(:user) { FactoryBot.create :user, :confirmed }
  let(:owner) { FactoryBot.create :user, :confirmed }
  let(:scope) { Pundit.policy_scope!(nil, [:federation, Following]) }
  let(:following) { FactoryBot.create :following, actor: owner.actor, target_actor: user.actor }

  permissions '.scope' do
    it 'returns all the followings' do
      following
      expect(scope.all.count).to eq 1
    end
  end

  permissions :show? do
    context 'when unauthenticated' do
      it 'grants access' do
        expect(described_class).to permit(nil, following)
      end
    end

    context 'when authenticated' do
      it 'grants access' do
        expect(described_class).to permit(user, following)
      end
    end
  end
end
