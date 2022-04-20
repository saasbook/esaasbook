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

        post :annotate, params: { chapter: '1', section: '4', annotation: 'hello world' }

        @annotation_find = @user.page_annotations.find_by(chapter: '1', section: '4')
        expect(@annotation_find).not_to be_nil
      end
    end
  end
end
