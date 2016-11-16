class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    
    if @answer.save
      flash[:success] = "Congratulations! Answer created!"
    else
      flash[:error] = "Answer is not created! Try later!"
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
