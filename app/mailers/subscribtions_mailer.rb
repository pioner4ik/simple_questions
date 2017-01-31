class SubscribtionsMailer < ApplicationMailer

  def news(user, answer)
    @user = user
    @answer = answer
    mail to: @user.email
  end
end
