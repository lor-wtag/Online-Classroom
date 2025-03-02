class Assignment < ApplicationRecord
  belongs_to :classroom

  has_many_attached :files
  has_many :submissions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true, length: { in: (5..200) }
  validates :classroom_id, presence: true
  validate :due_date_cannot_be_in_the_past

  def self.ransackable_attributes(auth_object = nil)
    %w[index title description due_date]
  end

  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date < Time.now
      errors.add(:due_date, "can't be in the past")
    end
  end
end
