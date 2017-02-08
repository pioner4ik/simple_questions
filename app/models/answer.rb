class Answer < ApplicationRecord
  include Attachable
  include Commentable
  include Votable

  default_scope -> { order("best DESC") }

  after_create { QuestionSubscribtionsJob.perform_later(self) }

  belongs_to :user
  belongs_to :question, touch: true

  validates :body, presence: true

  def mark_answer_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
