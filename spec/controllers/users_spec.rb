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
        @user = User.find_by(uid: 43_231, provider: 'github')
        get :show, params: {user: @user}
        expect(response).not_to be_nil
        expect(response.body).to include('Gob Github')
      end
    end
  end
end
