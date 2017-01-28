class QuestionSubscribtionsJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    @answer = answer
    subscribtions = @answer.question.subscribtions

    unless subscribtions.blank?
      subscribtions.find_each.each do |subscribtion|
        SubscribtionsMailer.news(subscribtion.user, @answer).deliver_later
      end
    end
  end
end
