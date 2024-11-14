class PostMailer < ApplicationMailer
  def new_post_notification(classroom, user, post)
    @classroom= classroom
    @user = user
    @post = post
    mail(to: @user.email, subject: "New post in #{@classroom.name}")
  end
end
