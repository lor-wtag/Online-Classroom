class User < ApplicationRecord
  has_one_attached :profile_picture
  enum role: { admin: 0, teacher: 1, student: 2 }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
