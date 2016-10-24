class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  # Get current login user.
  def current_user
    if session[:user_id].present?
      User.find_by_id(session[:user_id])
    end
  end
end
