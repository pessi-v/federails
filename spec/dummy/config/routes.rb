Rails.application.routes.draw do
  mount Federails::Engine => '/federails'

  get '/', to: 'home#home'
end
