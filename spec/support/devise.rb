module DeviseAcceptanceSpecHelpers
  include Warden::Test::Helpers

  def sign_in(resource_or_scope, resource = nil)
    resource ||= resource_or_scope
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    login_as(resource, scope: scope)
  end

  def sign_out(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    logout(scope)
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include DeviseAcceptanceSpecHelpers, type: :acceptance
  config.include DeviseAcceptanceSpecHelpers, type: :request
end
