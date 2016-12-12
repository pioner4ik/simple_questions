class Answer < ApplicationRecord
  include Attachable
  include Votable

  default_scope -> { order("best DESC") }

  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def mark_answer_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
