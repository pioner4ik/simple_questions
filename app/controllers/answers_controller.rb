class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    
    if @answer.save
      flash[:success] = "Congratulations! Answer created!"
      redirect_to @question
    else
      flash[:danger] = "Answer is not created! Try later!"
      render "questions/show" if @answer.persisted?
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      flash[:success] = "Answer deleted!"
      @answer.destroy
    else
      flash[:danger] = "Answer is not deleted! Please sign in as author!"
    end
      redirect_to questions_path
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
