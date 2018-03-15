Rails.application.routes.draw do
  devise_for :admins

  use_doorkeeper do
  # it accepts :authorizations, :tokens, :applications and :authorized_applications
  # controllers :applications => 'custom_applications'
  # controllers applications: :custom_applications
end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api/v1' do
    resources :members, only: :index
    resources :scholars, only: :index
    resources :friends, only: :index
    resources :donations, only: :index
  end

  # root 'home#landing'
  root 'welcome#index'

  namespace :admin do
    resources :dashboard
    resource :salesforce_connect
    resources :admin
  end

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get 'explore(/:country)' => 'stats#explore'
  get 'search/members' => 'search/members#index'
  get 'search/members/:id', to: 'search/members#show', as: :show_search_members
  get 'search/scholars' => 'search/scholars#index'
  get 'search/scholars/:id', to: 'search/scholars#show', as: :show_search_scholars
  post 'search/members' => 'search/members#index'
  get 'search/scholars' => 'search/scholars#index'
  get 'get_cities' => 'stats#get_cities'
  get 'get_search_results' => 'stats#get_search_results'
  get 'history' => 'stats#history'
  get 'demographics(/:type)' => 'stats#demographics'

end
