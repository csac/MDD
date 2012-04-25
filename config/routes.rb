Mdd::Application.routes.draw do
  devise_for :users

  root :to => 'keyword_categories#index'

  resources :keyword_categories
end

