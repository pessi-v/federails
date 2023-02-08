Federails::Engine.routes.draw do
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
