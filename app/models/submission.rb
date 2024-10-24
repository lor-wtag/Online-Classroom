class Submission < ApplicationRecord
  belongs_to :assignment
  belong_to :student, class_name: "User"

  validates :assignment_id, presence: true
  validates :student_id, presence: true
  validates :file, presence: true
  validates :grade, numericality: {allow_nil: true}
  validates :feedback, length: {maximum: 300}, allow_nil: true
end
