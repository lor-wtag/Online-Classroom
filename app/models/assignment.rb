class Assignment < ApplicationRecord
  belongs_to :classroom

  has_many :submissions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true, length: { in: (5..200) }
  validates :classroom_id, presence: true
end
