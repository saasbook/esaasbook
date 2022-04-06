# frozen_string_literal: true

# spec/auth
require 'rails_helper'
require 'spec_helper'

RSpec.describe Users::OmniauthController, type: :controller do
  context 'get github' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    describe 'success' do
      it 'should redirect to the homepage with a happy message' do
        @fake_user = FactoryBot.create :user
        expect(User).to receive(:create_from_provider_data).and_return(@fake_user)
        get :github
        expect(flash[:alert]).to be_present
        expect(flash[:error]).not_to be_present
      end
    end

    describe 'failure' do
      it 'should redirect to the homepage with a sad message' do
        # Factorybot Build does not save the user, so should fail persist
        @fake_user = FactoryBot.build :user
        expect(User).to receive(:create_from_provider_data).and_return(@fake_user)
        get :github
        expect(flash[:alert]).to_not be_present
        expect(flash[:error]).to be_present
      end
    end
  end
end
