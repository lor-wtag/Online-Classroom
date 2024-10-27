class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  validates :assignment_id, presence: true
  validates :user_id, presence: true
  validates :file, presence: true
  validates :grade, numericality: {allow_nil: true}
  validates :feedback, length: {maximum: 300}, allow_nil: true
end
