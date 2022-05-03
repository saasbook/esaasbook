# frozen_string_literal: true

# Application controller for the entire project
class ApplicationController < ActionController::Base
  def after_sign_out_path_for(_resource_or_scope)
    home_path
  end
end
