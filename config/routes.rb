# frozen_string_literal: true

Rails.application.routes.draw do
  get 'saasbook/index'
  get '/', to: 'saasbook#index'
  get '/chapter/:chapter_id/section/:section_id', to: 'saasbook#show_section', as: 'section'
  get '/chapter/:chapter_id', to: 'saasbook#show_chapter', as: 'chapter'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
