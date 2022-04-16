# frozen_string_literal: true

Rails.application.routes.draw do
  get '/user/:user', to: 'users#show', as: 'user'
  get 'saasbook/index'
  get '/chapter/:chapter_id/section/:section_id', to: 'saasbook#show_section', as: 'section'
  get '/chapter/:chapter_id', to: 'saasbook#show_chapter', as: 'chapter'
  get '/preface', to: 'saasbook#preface', as: 'preface'
  get '/', to: 'saasbook#index', as: 'home'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth' }
end
