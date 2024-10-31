class SessionsController < ApplicationController
  def destroy
    logout current_user
    redirect_to root_path, notice: "You have been logged out!"
  end
  
  def new
  end
end
