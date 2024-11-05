class InvitationMailer < ApplicationMailer
  def invitation_mail(teacher, classroom,student_email)
    @teacher =teacher
    @classroom=classroom
    @join_link=join_classroom_url(classroom)
    mail to: student_email, subject: "Invitation to join classroom"
  end
end
