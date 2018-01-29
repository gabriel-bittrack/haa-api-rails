Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api/v1' do
    resources :members, only: :index
    resources :scholars, only: :index
    resources :friends, only: :index
  end

  # root 'home#landing'
  root 'welcome#index'
  namespace :admin do
    resources :dashboard
  end

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
