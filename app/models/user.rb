require "digest"

class User < ApplicationRecord
  attr_accessor :password
  has_one_attached :profile_picture
  before_save :hashPassword
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\z/i
  enum :role, { admin: 0, teacher: 1, student: 2 }
  validates :name, presence: true
  validates :email, presence: true, length: { in: 10..50 }, format: { with: EMAIL_REGEX }, uniqueness: true
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :password, presence: true, on: :create, length: { in: (8..20) }
  has_many :classrooms, foreign_key: :user_id, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :classrooms_as_student, through: :enrollments, source: :classroom

  def hashPassword
    if password.present?
      self.password_digest = Digest::SHA256.hexdigest(password)
    end
  end

  def self.authenticate(user_email, password)
    user=User.find_by(email: user_email)
    if user
      if user.password_digest==Digest::SHA256.hexdigest(password)
        user
      else nil
      end
    end
  end
end
