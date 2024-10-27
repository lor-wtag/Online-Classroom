class Enrollment < ApplicationRecord
  validates :student_id, presence: true
  validates :classroom_id, presence: true

  belongs_to :user
  belongs_to :classroom

  # Ensure that a student can only enroll in a classroom once
  validates_uniqueness_of :student_id, scope: :classroom_id
end