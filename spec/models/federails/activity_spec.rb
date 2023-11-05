require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:actor) { FactoryBot.create(:user, :confirmed).actor }
  let(:distant_actor) { FactoryBot.create :actor, :distant }
  let(:following) { FactoryBot.create :following, actor: actor, target_actor: distant_actor }
  let(:distant_following) { FactoryBot.create :following, actor: distant_actor, target_actor: actor }

  describe '.recipients' do
    context 'when activity creator is distant' do
      it 'does not notify actor' do
        activity = described_class.new actor: distant_actor
        expect(activity.recipients).to eq []
      end
    end

    context 'when creating a Following' do
      it 'notifies the target actor' do
        expect(following.activities.last.recipients).to eq [distant_actor]
      end
    end

    context 'when accepting a Following' do
      it 'notifies the Following creator' do
        distant_following.accept!
        expect(distant_following.activities.last.recipients).to eq [distant_actor]
      end
    end

    context 'when creating a Note' do
      it 'notifies the followers' do
        distant_following.accept!
        note = FactoryBot.create :note, actor: actor
        expect(note.activities.last.recipients).to eq [distant_actor]
      end
    end
  end
end
