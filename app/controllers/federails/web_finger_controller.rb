require 'fediverse/webfinger'

module Federails
  class WebFingerController < ApplicationController
    def find
      filter = {}
      filter[Federails::Configuration.user_username_field] = username
      @user = Federails::Configuration.user_model.find_by!(filter)
      render formats: [:json]
    end

    def host_meta
      render content_type: 'application/xrd+xml', formats: [:xml]
    end

    # TODO: complete missing endpoints

    private

    def username
      account = Fediverse::Webfinger.split_resource_account params.require(:resource)
      # Fail early if user don't _seems_ local
      raise ActiveRecord::RecordNotFound unless account && Fediverse::Webfinger.local_user?(account)

      account[:username]
    end
  end
end
