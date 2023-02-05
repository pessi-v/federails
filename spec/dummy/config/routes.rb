Rails.application.routes.draw do
  devise_for :users

  mount Federails::Engine => '/federails'

  get '/', to: 'home#home'
end
