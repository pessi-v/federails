require 'fediverse/webfinger'

module Federails
  class WebFingerController < ApplicationController
    def find
      @user = User.find_by! username: username
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
