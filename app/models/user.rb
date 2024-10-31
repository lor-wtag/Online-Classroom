class User < ApplicationRecord
  has_one_attached :profile_picture
  has_secure_password
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\z/i
  enum :role, { admin: 0, teacher: 1, student: 2 }
  validates :name, presence: true
  validates :email, presence: true, length: { in: 10..50 }, format: { with: EMAIL_REGEX }, uniqueness: true
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :password, confirmation: true, if: -> { password.present? }
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_many :classrooms, foreign_key: :user_id, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :classrooms_as_student, through: :enrollments, source: :classroom
end
