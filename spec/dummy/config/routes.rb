Rails.application.routes.draw do
  devise_for :users

  mount Federails::Engine => '/'

  get '/', to: 'home#home'
end
