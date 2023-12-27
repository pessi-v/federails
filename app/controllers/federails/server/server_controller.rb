module Federails
  module Server
    class ServerController < Federails::ApplicationController
      protect_from_forgery with: :null_session

      # def policy_scope(scope, policy_scope_class: nil)
      #   scope = [scope, :server] unless policy_scope_class
      #   super(scope, policy_scope_class: policy_scope_class)
      # end

      # def authorize(record, query = nil, policy_class: nil)
      #   record = [:server, record] unless policy_class
      #   super(record, query, policy_class: policy_class)
      # end
    end
  end
end
