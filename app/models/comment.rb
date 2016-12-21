class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  validates :content, length: { minimum: 5 }
end