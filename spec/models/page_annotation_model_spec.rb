# frozen_string_literal: true

# spec/auth
require 'rails_helper'
require 'spec_helper'

describe PageAnnotation do
  describe 'Accessing a page annotation through the User model' do
    it 'should return a page annotation' do
      @test_user = FactoryBot.create(:user)
      @test_annotation = @test_user.page_annotations.create(chapter: '1', section: '2', annotation: 'hi')
      @retrieve_annotation = @test_user.page_annotations.first
      expect(@test_annotation).to eq(@retrieve_annotation)
    end
  end
end
