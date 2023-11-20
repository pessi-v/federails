require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe '/followings', type: :request do
  let(:signed_in_user) { User.find_by email: 'user@example.com' }
  let(:target_actor) { FactoryBot.create(:user).actor }
  let(:following) { FactoryBot.create :following, actor: signed_in_user.actor, target_actor: target_actor }
  let(:incoming_following) { FactoryBot.create :following, actor: target_actor, target_actor: signed_in_user.actor }
  # Following. As you add validations to Following, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryBot.build(:following, actor: nil, target_actor: target_actor).attributes }

  let(:invalid_attributes) do
    { target_actor: nil }
  end

  describe 'POST /create' do
    context 'with unauthenticated user' do
      it 'redirects to the login page' do
        post federails.client_followings_url, params: { following: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with authenticated user' do
      before { sign_in signed_in_user }

      context 'with valid parameters' do
        it 'creates a new Following' do
          expect do
            post federails.client_followings_url, params: { following: valid_attributes }
          end.to change(Federails::Following, :count).by(1)
        end

        it 'redirects to the actors profile' do
          post federails.client_followings_url, params: { following: valid_attributes }
          expect(response).to redirect_to(federails.client_actor_url(signed_in_user.actor))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Following' do
          expect do
            post federails.client_followings_url, params: { following: invalid_attributes }
          end.not_to change(Federails::Following, :count)
        end

        it 'redirects to the actors profile' do
          post federails.client_followings_url, params: { following: invalid_attributes }
          expect(response).to redirect_to(federails.client_actor_url(signed_in_user.actor))
        end
      end
    end
  end

  describe 'POST /follow' do
    context 'with unauthenticated user' do
      it 'redirects to the login page' do
        post federails.follow_client_followings_url(account: target_actor.username)
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with authenticated user' do
      before { sign_in signed_in_user }

      context 'with valid account' do
        it 'creates the following' do
          expect do
            post federails.follow_client_followings_url(account: target_actor.username)
          end.to change(Federails::Following, :count).by 1
        end

        it 'redirects to the actor' do
          post federails.follow_client_followings_url(account: target_actor.username)
          expect(response).to redirect_to(federails.client_actor_url(signed_in_user.actor))
        end
      end

      context 'with invalid account' do
        it 'does not create a new Following' do
          expect do
            post federails.follow_client_followings_url(account: 'non_existing_account')
          end.not_to change(Federails::Following, :count)
        end

        it 'redirects to the actors list' do
          post federails.follow_client_followings_url(account: 'non_existing_account')
          expect(response).to redirect_to(federails.client_actors_url)
        end
      end
    end
  end

  describe 'PUT /id:/accept' do
    context 'with unauthenticated user' do
      it 'redirects to the login page' do
        put federails.accept_client_following_url(following)
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with authenticated user' do
      before { sign_in signed_in_user }

      context 'when user is the targeted user' do
        it 'changes the state of the following' do
          put federails.accept_client_following_url(incoming_following)
          incoming_following.reload
          expect(incoming_following).not_to be_pending
        end

        it 'redirects to the actors profile' do
          put federails.accept_client_following_url(incoming_following)
          expect(response).to redirect_to(federails.client_actor_url(incoming_following.actor))
        end
      end

      context 'when user is the following creator' do
        it 'does not change the state of the following' do
          expect do
            put federails.accept_client_following_url(following)
          end.to raise_error Pundit::NotAuthorizedError
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with unauthenticated user' do
      it 'redirects to the login page' do
        delete federails.client_following_url(following)
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with authenticated user' do
      before { sign_in signed_in_user }

      it 'destroys the requested following' do
        # Create following first
        following
        expect do
          delete federails.client_following_url(following)
        end.to change(Federails::Following, :count).by(-1)
      end

      it 'redirects to the actors profile' do
        delete federails.client_following_url(following)
        expect(response).to redirect_to(federails.client_actor_url(signed_in_user.actor))
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers