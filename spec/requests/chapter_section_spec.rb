# frozen_string_literal: true

# spec/requests
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Chapter and Section Requests', type: :request do
  describe 'GET section' do
    it 'Succeeeds and renders the correct page' do
      get section_path(chapter_id: 1, section_id: 1)
      expect(response).to be_successful
      assert_select 'span.section-number', '1.1.'
    end
  end
  describe 'GET chapter' do
    it 'Succeeeds and renders the correct page' do
      get chapter_path(chapter_id: 1)
      expect(response).to be_successful
      assert_select 'span.section-number', '1.'
    end
  end
end

RSpec.describe 'Index and Preface Requests', type: :request do
  describe 'GET /' do
    it 'Succeeeds and renders the correct page' do
      get home_path
      expect(response).to be_successful
      assert_select 'div.section', /Engineering Software as a Service: An Agile Approach Using Cloud Computing.+/
    end
  end
  describe 'GET preface' do
    it 'Succeeeds and renders the correct page' do
      get preface_path
      expect(response).to be_successful
      assert_select 'div.section', /Preface+/
    end
  end
end

RSpec.describe 'Search Requests', type: :request do
  describe 'GET search' do
    it 'Succeeeds and renders the correct page' do
      get search_path
      expect(response).to be_successful
      assert_select 'div.section', /Search+/
    end
  end
end
