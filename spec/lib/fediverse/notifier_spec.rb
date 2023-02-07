require 'rails_helper'
require 'fediverse/notifier'

RSpec.describe Fediverse::Notifier do
  include Routeable
  let(:local_actor) { FactoryBot.create(:user, :confirmed).actor }
  let(:distant_target_actor) { FactoryBot.create :actor, :distant }

  describe '#post_to_inboxes' do
    context 'when notifying distant actor' do
      let(:activity_to_distant_actor) do
        following = Following.create actor: local_actor, target_actor: distant_target_actor
        following.activities.last
      end

      it 'sends the activity payload' do
        VCR.use_cassette 'handle_follow_post' do
          allow(Faraday).to receive :post
          described_class.post_to_inboxes activity_to_distant_actor
          expect(Faraday).to have_received(:post)
        end
      end
    end
  end
end
