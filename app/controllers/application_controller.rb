class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  before_action :set_locale

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def authenticate_user!
    redirect_to root_path, alert: "You are not logged in!" unless user_logged_in?
  end

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

  def user_not_logged_in?
    !user_logged_in?
  end
  helper_method :user_not_logged_in?

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
