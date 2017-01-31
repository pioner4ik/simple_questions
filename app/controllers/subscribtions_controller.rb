class SubscribtionsController < ApplicationController
  authorize_resource
  
  def create
    @question = Question.find(params[:question_id])
    @subscribtion = @question.subscribtions.create(user: current_user)
  end

  def destroy
    @subscribtion = Subscribtion.find(params[:id])
    @subscribtion.destroy!
  end
end
  