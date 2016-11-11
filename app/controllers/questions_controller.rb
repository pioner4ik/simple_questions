class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @user = User.create
    @question = @user.questions.build
  end

  def edit
  end

  def create
    @user = User.create
    @question = @user.questions.build(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update_attributes(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  private

    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
