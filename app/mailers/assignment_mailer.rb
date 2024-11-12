class AssignmentMailer < ApplicationMailer
  def assignment_notification(classroom, student, assignment)
    @student = student
    @assignment = assignment
    @classroom = classroom
    mail(to: @student.email, subject: "New Assignment Posted: #{@assignment.title} in #{@classroom.name}")
  end
end
