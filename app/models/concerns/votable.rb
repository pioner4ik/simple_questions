module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def total_votes
    self.votes.where( present: true).size - self.votes.where( present: false).size
  end
end