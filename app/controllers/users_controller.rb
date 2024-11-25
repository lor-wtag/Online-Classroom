class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :new, :create ]
  load_and_authorize_resource
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
    @q = User.ransack(params[:q])
    @users = @q.result.order(:role)
  end

  def show
    @user= User.find(params[:id])
  end

  def edit
    @user= User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "Your profile has been updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @user= User.find(params[:id])
  end

  def destroy
    @user= User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: "Account deleted!"
  end

  private
  def user_params
    permitted = [ :name, :email, :password, :password_confirmation, :role ]
    params.require(:user).permit(permitted)
  end
end
