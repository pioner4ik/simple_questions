class AnswersController < ApplicationController
  #   def create
  #     @question = Question.find(params[:id])
  #     @answer = @question.answers.build(answer_params)
  #
  #     if @answer.save(answer_params)
  #       redirect_to question_path(@question)
  #       flash[:success] = "Answer has already created!"
  #     else
  #       render question_path(@question)
  #       flash[:alert] = "Answer is not created! Try later!"
  #     end
  #   end
  #
  #   private
  #
  #     def answer_params
  #       params.require(:answer).permit(:body)
  #     end
end
