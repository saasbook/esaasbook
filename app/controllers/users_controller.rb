class UsersController < ApplicationController
	before_action :authenticate_user!
	def show
		@user = current_user
		@annotations = @user.page_annotations
	end

end