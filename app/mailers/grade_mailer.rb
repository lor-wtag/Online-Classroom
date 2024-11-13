class GradeMailer < ApplicationMailer
  def grade_notification(student, assignment, grade, feedback)
    @student = student
    @assignment = assignment
    @grade = grade
    @feedback=  feedback
    @teacher = assignment.classroom.teacher

    mail(to: @student.email, subject: "Your grade for #{@assignment.title} has been updated")
  end
end
