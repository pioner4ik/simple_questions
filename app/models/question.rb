class Question < ApplicationRecord
  include Attachable
  include Commentable
  include Votable
  
  #default_scope -> { order("created_at DESC") }

  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true
end
