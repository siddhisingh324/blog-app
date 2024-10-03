# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        post 'registrations', to: 'registrations#create'
        post 'sessions', to: 'sessions#create'
      end

      resources :blogs, controller: 'blogs'
    end
  end
end
