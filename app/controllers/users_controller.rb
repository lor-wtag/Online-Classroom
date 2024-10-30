class UsersController < ApplicationController
  layout "admin"

  before_action :confirm_logged_in, except: [ :create, :new ]
  def new
    @user=User.new
  end

  def create
    @user=User.create(user_params)
    if @user.save
      session[:user_id]=@user.id
      flash[:notice]="User created successfully"
      redirect_to(home_landing_page_path)
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
    permitted = [:name, :email]
    if current_user && current_user.admin?
      permitted<< :role
      params.require(:user).permit(permitted)
    else
      params.require(:user).permit(permitted)
    end
  permitted << :password if action_name == 'create' || params[:user][:password].present?
  params.require(:user).permit(permitted)
  end

end
