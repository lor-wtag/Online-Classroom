class User < ApplicationRecord
  enum role: {admin: 0, teacher: 1, student: 2}
  validates :name, presence: true
  validates :email, presence:true, uniqueness: true
  
end
