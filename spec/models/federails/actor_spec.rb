require 'rails_helper'

module Federails
  # rubocop:disable RSpec/MultipleMemoizedHelpers
  RSpec.describe Actor, type: :model do
    let(:distant_actor_attributes) { FactoryBot.build(:actor, :distant).attributes }
    let(:distant_url) { 'https://mamot.fr/users/mtancoigne' }
    let(:distant_account) { 'mtancoigne@mamot.fr' }
    let(:existing_distant_actor) { FactoryBot.create :actor, :distant, federated_url: distant_url, username: 'mtancoigne', server: 'mamot.fr' }
    # Cassette which should not be created by any example. Used to test the absence
    # of outgoing requests
    let(:error_cassette) { 'this_should_not_be_here' }
    let(:error_cassette_file) { File.join(VCR.configuration.cassette_library_dir, "#{error_cassette}.yml") }

    before do
      FileUtils.rm_f error_cassette_file
    end

    context 'when creating distant actors' do
      it 'fails to create the same actor twice' do
        described_class.create! distant_actor_attributes
        duplicate = described_class.new(distant_actor_attributes)
        duplicate.validate
        expect(duplicate.errors.details[:federated_url][0][:error]).to eq :taken
      end
    end

    context 'when creating local actors' do
      it 'fails to create the same local actor twice' do
        user = FactoryBot.create :user, :confirmed
        duplicate = described_class.new(user: user)
        duplicate.validate
        expect(duplicate.errors.details[:user_id][0][:error]).to eq :taken
      end
    end

    describe '#find_by_account' do
      it 'returns local actors' do
        user = FactoryBot.create :user, :confirmed, username: 'toto'
        result = described_class.find_by_account('toto@localhost')
        expect(result).to eq user.actor
      end

      it 'returns distant actors' do
        VCR.use_cassette 'actor/find_by_account_get' do
          result = described_class.find_by_account(distant_account)
          expect(result.username).to eq 'mtancoigne'
        end
      end

      it 'returns persisted distant actors' do
        VCR.use_cassette 'actor/find_by_account_get' do
          existing_distant_actor
          result = described_class.find_by_account(distant_account)
          expect(result.id).to eq existing_distant_actor.id
        end
      end

      it 'returns distant actors without making a call' do
        # This should not create new cassettes; if this one is created there is an issue
        VCR.use_cassette 'this_should_not_be_here' do
          existing_distant_actor
          described_class.find_by_account(distant_account)
        end
        # rubocop:disable RSpec/PredicateMatcher
        expect(File.exist?(error_cassette_file)).to be_falsey
        # rubocop:enable RSpec/PredicateMatcher
      end
    end

    describe '#find_or_create_by_account' do
      it 'creates distant actor' do
        VCR.use_cassette 'actor/find_or_create_by_account_get' do
          expect do
            described_class.find_or_create_by_account(distant_account)
          end.to change(described_class, :count).by 1
        end
      end

      it 'does not create existing distant actor' do # rubocop:disable RSpec/ExampleLength
        VCR.use_cassette 'actor/find_or_create_by_account_get' do
          existing_distant_actor
          expect do
            described_class.find_by_account(distant_account)
          end.not_to change(described_class, :count)
        end
      end
    end

    describe '#find_by_federation_url' do
      it 'returns local actors' do
        user = FactoryBot.create :user, :confirmed, username: 'toto'
        result = described_class.find_by_federation_url(user.actor.federated_url)
        expect(result).to eq user.actor
      end

      it 'returns distant actors' do
        VCR.use_cassette 'actor/find_by_federation_url_get' do
          result = described_class.find_by_federation_url(distant_url)
          expect(result.username).to eq 'mtancoigne'
        end
      end

      it 'returns persisted distant actors' do
        VCR.use_cassette 'actor/find_by_federation_url_get' do
          existing_distant_actor
          result = described_class.find_by_federation_url(distant_url)
          expect(result.id).to eq existing_distant_actor.id
        end
      end

      it 'returns distant actors without making a call' do
        # This should not create new cassettes; if this one is created there is an issue
        VCR.use_cassette error_cassette do
          existing_distant_actor
          described_class.find_by_federation_url(distant_url)
        end
        # rubocop:disable RSpec/PredicateMatcher
        expect(File.exist?(error_cassette_file)).to be_falsey
        # rubocop:enable RSpec/PredicateMatcher
      end
    end

    describe '#find_or_create_by_federation_url' do
      it 'creates distant actor' do
        VCR.use_cassette 'actor/find_or_create_by_federation_url_get' do
          expect do
            described_class.find_or_create_by_federation_url(distant_url)
          end.to change(described_class, :count).by 1
        end
      end

      it 'does not create existing distant actor' do # rubocop:disable RSpec/ExampleLength
        VCR.use_cassette 'actor/find_or_create_by_federation_url_get' do
          existing_distant_actor
          expect do
            described_class.find_or_create_by_federation_url(distant_url)
          end.not_to change(described_class, :count)
        end
      end
    end

    describe '#find_or_create_by_object' do
      context 'when a String is given' do
        it 'fetches the distant actor' do
          allow(described_class).to receive :find_or_create_by_federation_url
          described_class.find_or_create_by_object distant_url
          expect(described_class).to have_received(:find_or_create_by_federation_url).with(distant_url)
        end
      end

      context 'when a Hash is given' do
        it 'fetches the distant actor' do
          hash = { 'id' => distant_url }
          allow(described_class).to receive :find_or_create_by_federation_url
          described_class.find_or_create_by_object hash
          expect(described_class).to have_received(:find_or_create_by_federation_url).with(distant_url)
        end
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
