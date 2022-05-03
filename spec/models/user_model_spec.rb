# frozen_string_literal: true

# spec/auth
require 'rails_helper'
require 'spec_helper'

describe User do
  describe 'Using create_from_provider_data Method on an existing user' do
    it 'should return the applicable user' do
      @test_user = FactoryBot.create(:user)
      @test_data = double(provider: 'github', uid: 43_231, nickname: 'GGHub')
      @found_user = User.create_from_provider_data(@test_data)
      expect(@found_user).to eq(@test_user)
    end
  end
  describe 'Using create_from_provider_data Method on a non-existing user' do
    it 'should create the applicable user and return it' do
      # Make sure the user doesn't already exist
      @found_user = User.find_by(uid: 1337, provider: 'github')
      expect(@found_user).not_to be_present
      # Set up some doubles
      @test_info = double(email: 'Will Smith', nickname: 'Will')
      @test_data = double(provider: 'github', uid: 1337, info: @test_info)
      # Test the actual method
      @created_user = User.create_from_provider_data(@test_data)
      # See if the user now exists
      @found_user = User.find_by(uid: 1337, provider: 'github')
      expect(@found_user).to be_present
      expect(@found_user).to eq(@created_user)
    end
  end
end
