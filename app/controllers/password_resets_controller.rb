class PasswordResetsController < ApplicationController
  def new
  end

  def create
    if (user= User.find_by(email: params[:email]))
      PasswordMailer.with(
        user: user,
        token: user.generate_token_for(:password_reset)
      ).password_reset.deliver_later
    end

    redirect_to root_path, notice: "Check your email to rest your password"
  end

  def edit
  end

  def update
  end

  private
  def set_user_by_token
    @user=User.find_by_token_for(:password_reset, params[:token])
    redirect_to new_password_resets_path unless @user.present?
  end
end
