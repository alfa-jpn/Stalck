Rails.application.routes.draw do
  root controller: :messages, action: :index
  resources :messages, only: [:index]
end
