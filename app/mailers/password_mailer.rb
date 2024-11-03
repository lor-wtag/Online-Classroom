class PasswordMailer < ApplicationMailer
  def password_reset
    mail to: params[:user].email, subject: "Reset your Password"
  end
end
