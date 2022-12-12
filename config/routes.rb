# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  namespace :simc do
    resources :reports, only: [:show]
  end
  namespace :warcraft_logs do
    resources :reports, only: [:index]
    resources :fights, only: [:index]
  end

  # resources :users, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
