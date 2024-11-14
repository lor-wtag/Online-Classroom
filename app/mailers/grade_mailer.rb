require "prawn"
class GradeMailer < ApplicationMailer
  def grade_notification(student, assignment, grade, feedback)
    @student = student
    @assignment = assignment
    @grade = grade
    @feedback=  feedback
    @teacher = assignment.classroom.teacher

    pdf = generate_grade_pdf(@grade, @feedback, @student, @assignment)

    attachments["#{@assignment.title}_grade_feedback.pdf"] = pdf.render

    mail(to: @student.email, subject: "Your grade for #{@assignment.title} has been updated")
  end

  private

  def generate_grade_pdf(grade, feedback, student, assignment)
    Prawn::Document.new do |pdf|
      pdf.text "Grades of your submission", size: 18, style: :bold
      pdf.move_down 20

      pdf.text "Student: #{student.name}", size: 14
      pdf.text "Assignment: #{assignment.title}", size: 14
      pdf.move_down 10

      pdf.text "Grade: #{grade}", size: 14, style: :bold
      pdf.text "Feedback: #{feedback}", size: 12
    end
  end

end