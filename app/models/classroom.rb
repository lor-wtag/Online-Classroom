class Classroom < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :course_code, presence: true, uniqueness: true

  belongs_to :teacher, class_name: "User", foreign_key: "user_id"
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  has_many :assignments, dependent: :destroy
  has_many :posts, dependent: :destroy
end
