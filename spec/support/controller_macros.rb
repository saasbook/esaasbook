# frozen_string_literal: true

# Macros for rspec controller tests
module ControllerMacros
  # Support for devise login_user method
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create :user
      sign_in user
    end
  end
end
