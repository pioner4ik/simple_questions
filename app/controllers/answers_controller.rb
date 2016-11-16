class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    
    if @answer.save
      flash[:success] = "Congratulations! Answer created!"
      redirect_to @question
    else
      flash[:danger] = "Answer is not created! Try later!"
      redirect_to @question
    end
  end

  def destroy
    @answer = Answer.find(params[:question_id])
    if current_user == @answer.user
      flash[:success] = "Answer deleted!"
      @answer.destroy
      redirect_to questions_path
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
