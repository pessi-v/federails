Federails::Engine.routes.draw do
  get '/.well-known/webfinger', to: 'web_finger#find', as: :webfinger
  get '/.well-known/host-meta', to: 'web_finger#host_meta', as: :host_meta
  get '/.well-known/nodeinfo', to: 'web_finger#node_info', as: :node_info
  get '/nodeinfo/2.0', to: 'web_finger#show_node_info', as: :show_node_info

  scope Federails.configuration.routes_path do
    resources :actors, only: [:show] do
      member do
        get :followers
        get :following
      end
      get :outbox, to: 'activities#outbox'
      post :inbox, to: 'activities#create'
      resources :activities, only: [:show]
      resources :followings, only: [:show]
      resources :notes, only: [:show]
    end
  end
end
