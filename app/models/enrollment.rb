class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :classroom

  validates :student_id, presence: true
  validates :classroom_id, presence: true
  # Ensure that a student can only enroll in a classroom once
  validates_uniqueness_of :user_id, scope: :classroom_id
end
