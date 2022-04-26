# frozen_string_literal: true

Rails.application.routes.draw do
  get '/user/profile', to: 'users#profile', as: 'user'
  get 'saasbook/index'
  get '/chapter/:chapter_id/section/:section_id', to: 'saasbook#show_section', as: 'section'
  get '/chapter/:chapter_id', to: 'saasbook#show_chapter', as: 'chapter'
  get '/preface', to: 'saasbook#preface', as: 'preface'
  get '/', to: 'saasbook#index', as: 'home'
  post '/annotate', to: 'saasbook#annotate', as: 'annotate'
  get '/fetch_annotations', to: 'saasbook#fetch_annotations', as: 'fetch_annotations'

  get '/search', to: 'saasbook#search'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth' }
end
