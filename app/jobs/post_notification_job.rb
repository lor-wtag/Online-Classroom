class PostNotificationJob < ApplicationJob
  queue_as :default

  def perform(classroom, post)
    classroom.users.each do |student|
      if student!=post.user
        PostMailer.new_post_notification(classroom, student, post).deliver_later
      end
    end
    if classroom.teacher!=post.user
      PostMailer.new_post_notification(classroom, classroom.teacher, post).deliver_later
    end
  end
end
