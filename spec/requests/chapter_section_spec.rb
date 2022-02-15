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
