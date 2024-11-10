class SessionsController < ApplicationController
  def destroy
    logout current_user
    redirect_to root_path, notice: "You have been logged out!"
  end

  def new
  end

  def create
      if user=User.authenticate_by(email: params[:email], password: params[:password])
        login user
        redirect_to root_path, notice: "You have logged in! :D"
      else
        flash[:alert]="Invalid username/password"
        render :new, status: :unprocessable_entity
      end
  end
end
