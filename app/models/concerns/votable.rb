module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    votes.create(user: user, value: -1)
  end

  def reset_votes(user)
    votes.where(user_id: user.id).destroy_all
  end

  def total_votes
    votes.sum(:value)
  end
  
  def check_vote_is_present(user)
    votes.where(user: user).exists?
  end
end