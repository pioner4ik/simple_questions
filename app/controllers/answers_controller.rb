class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash.now[:success] = "Congratulations! Answer created!"
    else
      flash.now[:danger] = "Answer is not created! Try later!"
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
      flash[:warning] = "Answer deleted!"
      @answer.destroy
    else
      flash[:danger] = "Answer is not deleted! Please sign in as author!"
    end
      redirect_to question_path(@answer.question)
  end

  def answer_best
    @question = @answer.question
    @answer.mark_answer_best if current_user.author_of?(@question)
  end

  private

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
