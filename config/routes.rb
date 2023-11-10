Federails::Engine.routes.draw do
  scope path: '/' do
    get '/.well-known/webfinger', to: 'web_finger#find', as: :webfinger
    get '/.well-known/host-meta', to: 'web_finger#host_meta', as: :host_meta
    get '/.well-known/nodeinfo', to: 'nodeinfo#index', as: :node_info
    get '/nodeinfo/2.0', to: 'nodeinfo#show', as: :show_node_info
  end
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
