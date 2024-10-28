class SessionsController < ApplicationController

  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]
  def login
  end

  def attempt_login
    if params[:email].present? && params[:password].present?
      user=User.authenticate(params[:email],params[:password])
      if user
        session[:user_id]=user.id
        redirect_to sessions_landing_page_path, notice: "#{user.name} User logged in successfully"
      else
        flash.now[:notice]= "Invalid username/Password. Please try again! :("
        render("login")
      end
    end
  end

  def logout
    session[:user_id]=nil
    flash[:notice]= "You are logged out"
    redirect_to sessions_login_path
  end

  def landing_page

  end
end
