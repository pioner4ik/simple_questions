class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.where(created_at: (1.day.ago)..(Time.now)).to_a
    unless questions.blank?
      User.find_each.each do |user|
        DailyMailer.digest(user, questions).deliver_later
      end
    end
  end
end
