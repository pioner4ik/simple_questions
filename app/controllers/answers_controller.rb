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
      render "questions/show"
=begin
  здесь выдает ошибку undefined method `answers_path' for #<#<Class:0xbbf75b0>:0xd920970>
  1 тест не проходит
  я так понимаю ошибка лежит в самом шаблоне show,а именно в строке = link_to "delete",  answer в самом answer
  неправильно задаю путь.Но если честно,ума не приложу какой писать путь.Пробовал [@question, answer] и 
  question_answer_path(answer), не помогло.Через "визуальный тест" все в порядке
=end      
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
