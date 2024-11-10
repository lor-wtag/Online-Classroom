class Post < ApplicationRecord
  belongs_to :classroom
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :title, presence: true, length: { in: (5..100) }
  validates :content, presence: true, length: { in: (5..300) }
  validates :user_id, presence: true
  validates :classroom_id, presence: true

end
