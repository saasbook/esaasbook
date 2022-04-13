# frozen_string_literal: true

# Controller for the omniauth.
module Users
  # Currently only contains github callback, but could be extended later.
  class OmniauthController < ApplicationController
    # github callback
    def github
      @user = User.create_from_provider_data(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_and_redirect @user
        flash[:alert] = 'Signed in with github!'
      else
        failure
      end
    end

    def failure
      # Can change redirect/message later
      flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
      redirect_to home_path
    end
  end
end
