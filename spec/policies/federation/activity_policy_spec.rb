require 'rails_helper'

RSpec.describe Federails::ActivityPolicy, type: :policy do
  let(:signed_in_user) { FactoryBot.create :user, :confirmed }
  let(:scope) { Pundit.policy_scope!(nil, Activity) }

  permissions '.scope' do
    it 'returns all the activities' do
      FactoryBot.create_list :note, 2, actor: signed_in_user.actor

      expect(scope.all.count).to eq 2
    end
  end

  permissions :index? do
    context 'when unauthenticated' do
      it 'grants access' do
        expect(described_class).to permit(nil, Activity)
      end
    end

    context 'when authenticated' do
      it 'grants access' do
        expect(described_class).to permit(signed_in_user, Activity)
      end
    end
  end
end
