class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  has_many_attached :files
  has_many :comments, as: :commentable, dependent: :destroy
  validates :assignment_id, presence: true
  validates :user_id, presence: true
  validates :grade, numericality: { allow_nil: true }
  validates :feedback, length: { maximum: 300 }, allow_nil: true
  def self.ransackable_attributes(auth_object = nil)
    %w[index grade created_at feedback]
  end
  before_create :check_if_late

  private

  def check_if_late
    self.late = assignment.due_date < created_at
  end
end
