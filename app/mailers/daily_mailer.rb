class DailyMailer < ApplicationMailer

  def digest(user, questions)
    @questions = questions
    @user = user.email
    mail to: @user
  end
end
