class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :vote_type, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def total_votes
    self.votes.where( present: true).size - self.votes.where( present: false).size
  end
end
