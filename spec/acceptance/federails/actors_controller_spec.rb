require 'rails_helper'

RSpec.describe Federails::ActorsController, type: :acceptance do
  resource 'Federation/Actors', 'Actors management'

  entity :actor,
         '@context':        { type: :string, description: 'JSON-LD contexts' },
         id:                { type: :string, description: 'Federated id' },
         type:              { type: :string, description: 'Actor type' },
         name:              { type: :string, description: 'Human name' },
         preferredUsername: { type: :string, description: 'Immutable username' },
         inbox:             { type: :string, description: 'Federated inbox URL' },
         outbox:            { type: :string, description: 'Federated outbox URL' },
         followers:         { type: :string, description: 'URL to the followers list' },
         following:         { type: :string, description: 'URL to the followings list' },
         url:               { type: :string, required: false, description: 'URL to a human readable profile' }

  entity :actors_ordered_collection_page,
         # Base
         id:           { type: :string, description: 'Unique identifier' },
         type:         { type: :string, description: 'Object type (OrderedCollectionPage)' },
         # CollectionPage
         partOf:       { type: :string, description: 'URL to the collection to which this CollectionPage belong' },
         next:         { type: :string, required: false, description: 'URL to the next page of items' },
         prev:         { type: :string, required: false, description: 'URL to the previous page of items' },
         # OrderedCollection/Collection
         totalItems:   { type: :integer, description: 'Total number of following/followers in this collection' },
         # first:        { type: :string, description: 'URL to the furthest preceding page' },
         # last:         { type: :string, description: 'URL to the furthest proceeding page' },
         orderedItems: { type: :array, description: 'List of followings on current page' }
  entity :actors_ordered_collection,
         '@context': { type: :string, description: 'JSON-LD context' },
         # Base
         id:         { type: :string, description: 'Unique identifier' },
         type:       { type: :string, description: 'Object type (OrderedCollection)' },
         # CollectionPage (except items)
         totalItems: { type: :integer, description: 'Total number of pages in this collection' },
         current:    { type: :object, description: 'OrderedCollectionPage with list of actor IDs', attributes: :actors_ordered_collection_page },
         first:      { type: :string, description: 'URL to the furthest preceding page' },
         last:       { type: :string, description: 'URL to the furthest proceeding page' }

  parameters :actor_path_params,
             id: { type: :integer, description: 'Actor record identifier (not the federation id).' }

  let(:actor) { FactoryBot.create(:user).actor }
  let(:following) do
    FactoryBot.create_list(:user, 2).each do |user|
      Federails::Following.create actor: actor, target_actor: user.actor
    end
  end
  let(:followers) do
    FactoryBot.create_list(:user, 2).each do |user|
      Federails::Following.create actor: user.actor, target_actor: actor
    end
  end

  on_get '/federation/actors/:id', 'Display one actor' do
    path_params defined: :actor_path_params

    for_code 200, expect_one: :actor do |url|
      test_response_of url, path_params: { id: actor.id }
    end

    for_code 404, expect_one: :error do |url|
      test_response_of url, path_params: { id: 0 }
    end
  end

  on_get '/federation/actors/:id/followers', 'Followers list' do
    path_params defined: :actor_path_params

    for_code 200, expect_one: :actors_ordered_collection do |url|
      followers
      test_response_of url, path_params: { id: actor.id }
    end

    for_code 404, expect_one: :error do |url|
      followers
      test_response_of url, path_params: { id: 0 }
    end
  end

  on_get '/federation/actors/:id/following', 'List of followed actors' do
    path_params defined: :actor_path_params

    for_code 200, expect_one: :actors_ordered_collection do |url|
      following
      test_response_of url, path_params: { id: actor.id }
    end

    for_code 404, expect_one: :error do |url|
      following
      test_response_of url, path_params: { id: 0 }
    end
  end
end
