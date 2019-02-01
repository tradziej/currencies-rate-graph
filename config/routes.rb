Rails.application.routes.draw do
  namespace :api do
    get 'exchange_rates/index'
  end
  get 'home/show'
  root :to => 'home#show'
end
