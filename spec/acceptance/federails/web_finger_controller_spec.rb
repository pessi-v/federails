require 'rails_helper'

RSpec.describe Federails::WebFingerController, type: :acceptance do
  resource 'Webfinger', 'Webfinger endpoints'

  entity :webfinger,
         subject: { type: :string, description: 'Subject to find' },
         links:   { type: :array, description: 'List of available links for the actor', of: {
           rel:  { type: :string, description: 'Link descriptor' },
           type: { type: :string, description: 'Media type' },
           href: { type: :string, description: 'URL' },
         } }

  on_get '/.well-known/webfinger?resource=:resource', 'List activities' do
    path_params fields: { resource: { type: :string, description: 'actor address, e.g.: "acct:user@server.tld"' } }

    for_code 200, expect_one: :webfinger do |url|
      user = FactoryBot.create :user
      # Use the user's id as username in dummy app, as there is no username field on the user's table
      test_response_of url, path_params: { resource: "acct:#{user.id}@localhost" }
    end

    for_code 404, expect_one: :error do |url|
      test_response_of url, path_params: { resource: 'acct:john@doe-service.org' }
    end
  end
end
