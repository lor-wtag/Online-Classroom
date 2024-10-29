class UsersController < ApplicationController
  def new
    @user=User.new
  end

  def create
    @user=User.create(user_params)
    if @user.save
      session[:user_id]=@user.id
      flash[:notice]="User created successfully"
      redirect_to(sessions_landing_page_path)
    else
      render("new")
    end
  end

  def index
    @users=User.all
  end

  def edit
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :role, :password)
  end
end
