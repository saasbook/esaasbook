# frozen_string_literal: true

# spec/auth
require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  context 'attempting to open a user page' do
    render_views
    describe 'success' do
      login_user
      it 'should show username' do
        get :profile
        expect(response).not_to be_nil
        expect(response.body).to include('Gob Github')
      end
    end
  end
  context 'page path helper' do
    render_views
    describe 'Having an annotation on the home page' do
      login_user
      it 'should show the title of the home page' do
        @user = User.first
        @page = Page.create(chapter: 0, section: 0, title: 'This is the home page title now')
        @test_annotation = @user.page_annotations.create(chapter: '0', section: '0', annotation: 'hi', page: @page)
        get :profile
        expect(response).to be_successful
        expect(response.body).to include('This is the home page title now')
      end
    end
    describe 'Having an annotation on the preface page' do
      login_user
      it 'should show the title of the preface page' do
        @user = User.first
        @page = Page.create(chapter: 0, section: 1, title: 'This is the preface page title now')
        @test_annotation = @user.page_annotations.create(chapter: '0', section: '1', annotation: 'hi', page: @page)
        get :profile
        expect(response).to be_successful
        expect(response.body).to include('This is the preface page title now')
      end
    end
    describe 'Having an annotation on a normal chapter/section page' do
      login_user
      it 'should show the title of the page, along with chapter.section indicator page' do
        @user = User.first
        @page = Page.create(chapter: 4, section: 5, title: 'MyFavoritePageTitle')
        @test_annotation = @user.page_annotations.create(chapter: '4', section: '5', annotation: 'hi', page: @page)
        get :profile
        expect(response).to be_successful
        expect(response.body).to include('4.5 MyFavoritePageTitle')
      end
    end
    describe 'Having an annotation on a chapter page' do
      login_user
      it 'should show the title of the page, along with chapter.section indicator page' do
        @user = User.first
        @page = Page.create(chapter: 4, section: 0, title: 'MyFavoritePageTitle')
        @test_annotation = @user.page_annotations.create(chapter: '4', section: '0', annotation: 'hi', page: @page)
        get :profile
        expect(response).to be_successful
        expect(response.body).to include('4.0 MyFavoritePageTitle')
      end
    end
  end
end
