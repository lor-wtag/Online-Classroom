class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  has_many_attached :files
  has_many :comments, as: :commentable, dependent: :destroy
  validates :assignment_id, presence: true
  validates :user_id, presence: true
  validates :grade, numericality: { allow_nil: true }
  validates :feedback, length: { maximum: 300 }, allow_nil: true
end
