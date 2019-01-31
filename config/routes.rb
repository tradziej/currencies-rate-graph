Rails.application.routes.draw do
  get 'home/show'
  root :to => 'home#show'
end
