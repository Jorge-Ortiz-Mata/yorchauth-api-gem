Yorchauthapi::Engine.routes.draw do
  namespace :api do
    post '/login', to: 'sessions#login'
    delete '/logout', to: 'sessions#logout'
    resources :users
  end
end
