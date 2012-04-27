Mdd::Application.routes.draw do
  devise_for :users

  root :to => 'sheets#index'

  resources :keyword_categories
  resources :keywords
  resources :sheets
end

