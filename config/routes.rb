Rails.application.routes.draw do
  resources :players
  root 'players#new'
  post '/open_chest', to: 'players#open_chest', as: 'open_chest'
  post '/cashout', to: 'players#cashout', as: 'cashout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
