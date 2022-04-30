# frozen_string_literal: true

# Application Controller for user accounts
class UsersController < ApplicationController
  before_action :authenticate_user!
  def profile
    @user = current_user
    @annotations = @user.page_annotations
    @chapter_id = 0
    @section_id = -1
    @body_contents = 'user_page'
    @title = "#{@user.nickname}'s User Page"
    render('main_content')
  end
end
