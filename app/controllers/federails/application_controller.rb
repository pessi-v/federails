module Federails
  class ApplicationController < ActionController::Base
    include Pundit::Authorization
  end
end
