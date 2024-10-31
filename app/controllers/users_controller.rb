class UsersController < ApplicationController
  def new
    @user=User.new
  end

  def create
    @user=User.create(user_params)
    if @user.save
      login @user
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users=User.all
  end

  private
  def user_params
    permitted = [ :name, :email, :password, :password_confirmation ]
    if current_user && current_user.admin?
      permitted<< :role
    end
      params.require(:user).permit(permitted)
  end
end
