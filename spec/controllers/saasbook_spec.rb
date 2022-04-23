# frozen_string_literal: true

# spec/auth
require 'rails_helper'
require 'spec_helper'

RSpec.describe SaasbookController, type: :controller do
  context 'attempting to create an annotation' do
    describe 'success' do
      login_user
      it 'should create a new annotation' do
        @user = User.find_by(uid: 43_231, provider: 'github')
        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find).to be_nil
        @num_annotations_before = PageAnnotation.count

        post :annotate, params: { chapter: '1', section: '4', annotation: 'hello world' }

        @num_annotations_after = PageAnnotation.count
        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find).not_to be_nil
        expect(@annotation_find.annotation).to eq('hello world')
        expect(@num_annotations_after).to eq(@num_annotations_before + 1)
      end
    end
    describe 'overwriting an existing annotation' do
      login_user
      it 'should replace the annotation with a new one' do
        @user = User.find_by(uid: 43_231, provider: 'github')
        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find).to be_nil
        @num_annotations_before = PageAnnotation.count

        post :annotate, params: { chapter: '1', section: '4', annotation: 'hello world' }

        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find.annotation).to eq('hello world')
        @num_annotations_after = PageAnnotation.count
        expect(@num_annotations_after).to eq(@num_annotations_before + 1)

        post :annotate, params: { chapter: '1', section: '4', annotation: 'goodbye moon' }

        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find.annotation).to eq('goodbye moon')
        @num_annotations_final = PageAnnotation.count
        expect(@num_annotations_final).to eq(@num_annotations_after)
      end
    end
    describe 'creating annotations on different pages' do
      login_user
      it 'should result in multiple annotations being present in the database' do
        @user = User.find_by(uid: 43_231, provider: 'github')
        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find).to be_nil
        @num_annotations_before = PageAnnotation.count

        post :annotate, params: { chapter: '1', section: '4', annotation: 'hello world' }

        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find.annotation).to eq('hello world')
        @num_annotations_after = PageAnnotation.count
        expect(@num_annotations_after).to eq(@num_annotations_before + 1)

        post :annotate, params: { chapter: '5', section: '5', annotation: 'goodbye moon' }

        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find.annotation).to eq('hello world')
        @annotation_find = @user.page_annotations.find_by(chapter: '5', section: '5')
        expect(@annotation_find.annotation).to eq('goodbye moon')
        @num_annotations_final = PageAnnotation.count
        expect(@num_annotations_final).to eq(@num_annotations_after + 1)
        expect(@num_annotations_final).to eq(@num_annotations_before + 2)
      end
    end
    describe 'making an annotation without logging in' do
      it 'should fail spectacularly' do
        @num_annotations_before = PageAnnotation.count

        post :annotate, params: { chapter: '1', section: '4', annotation: 'hello world' }

        @num_annotations_after = PageAnnotation.count

        expect(@num_annotations_after).to eq(@num_annotations_before)
      end
    end
    describe 'accessing the fetch_annotations page via hhtp' do
      it 'should redirect you' do
        get :fetch_annotations
        expect(response).to redirect_to(home_path)
      end
    end
    describe 'accessing the fetch_annotations page via hhtp' do
      it 'should redirect you' do
        get :fetch_annotations
        expect(response).to redirect_to(home_path)
      end
    end
    describe 'getting annotations from a page' do
      login_user
      it 'should return the annotation' do
        post :annotate, params: { chapter: '1', section: '4', annotation: 'hello world' }
        @user = User.find_by(uid: 43_231, provider: 'github')
        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find.annotation).to eq('hello world')

        get :fetch_annotations, params: { chapter: 1, section: 4 }, format: 'json'
        expect(response).not_to be_nil
        expect(response.body).to eq('hello world'.to_json)
      end
    end
  end
end
