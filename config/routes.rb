# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      namespace :users do
        post 'registrations', to: 'registrations#create'
        post 'sessions', to: 'sessions#create'
      end
    end
  end
end
