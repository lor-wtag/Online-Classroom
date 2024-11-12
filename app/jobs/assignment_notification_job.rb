class AssignmentNotificationJob < ApplicationJob
  queue_as :default

  def perform(classroom, assignment)
    students = classroom.users
    students.each do |student|
      AssignmentMailer.assignment_notification(classroom, student, assignment).deliver_later
    end
  end
end
