# frozen_string_literal: true

Rails.application.routes.draw do
  get 'saasbook/index'
  get '/chapter/:chapter_id/section/:section_id', to: 'saasbook#show_section', as: 'section'
  get '/chapter/:chapter_id', to: 'saasbook#show_chapter', as: 'chapter'
  get '/', to: 'saasbook#index'
end
