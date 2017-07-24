Rails.application.routes.draw do
  resource :users
  post 'users/sign_in', to: 'users#sign_in'
  post 'users/sign_up', to: 'users#sign_up'
  get 'users/table', to: 'users#show'
  root 'users#index'# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
