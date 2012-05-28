# encoding: utf-8
Mdd::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users

  root :to => 'sheets#index'

  resources :keyword_categories
  resources :keywords
  resources :sheets

  resources :search, only: [:index]
end

