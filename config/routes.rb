require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :user
  
  devise_scope :user do
    namespace :user do
      resources :subscriptions, only: [:index, :new, :create, :destroy]
      resources :filters
    end

    authenticated :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  get "feeds/:uuid" => "rss_feeds#show", as: :rss_feed
  get "feeds/combined/:uuid" => "rss_feeds#combined", as: :combined_rss_feed

  root "user/subscriptions#index"
end
