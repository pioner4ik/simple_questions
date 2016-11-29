class Answer < ApplicationRecord
  default_scope -> { order("best DESC") }

  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def mark_answer_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
