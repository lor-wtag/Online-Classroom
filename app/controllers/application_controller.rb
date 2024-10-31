class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
  def current_user
    Current.user ||= authenticate_from_session
  end
  helper_method :current_user

  def authenticate_from_session
    User.find_by(id: session[:user_id])
  end

  def user_logged_in?
    current_user.present?
  end
  helper_method :user_logged_in?

  def login(user)
    Current.user=user
    reset_session
    session[:user_id]=user.id
  end

  def logout(user)
    reset_session
    Current.user=nil
  end
end
