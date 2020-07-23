Rails.application.routes.draw do
  namespace :warcraft_logs do
    resources :reports, only: [:index]
  end
  resources :users, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
