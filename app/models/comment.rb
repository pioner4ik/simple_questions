class Comment < ApplicationRecord
  default_scope -> { order("created_at DESC") }

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :content, length: { minimum: 5 }
end
