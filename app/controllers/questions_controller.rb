class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :update, :destroy, :vote, :re_vote ]
  before_action :set_question, only: [:show, :update, :destroy]
  after_action :publish_question, only: :create

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:danger] = 'Error! Try later'
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)

      if @question.update(question_params)
        flash[:success] = "Your question succesfully updated!"
      else
        flash[:danger] = "Some problem, plz try later!"
      end
    else
      flash[:warning] = "Plz sign in as autor of question!"
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:success] = "Question deleted!"
      redirect_to questions_path
    else
      flash[:danger] = "Question is not deleted! Please sign in as author!"
      redirect_to @question
    end
  end

  private

    def set_question
      @question = Question.find(params[:id])
      gon.question_id = @question.id
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [ :id, :file, :_destroy ])
    end

    def publish_question
      return if @question.errors.any?
      ActionCable.server.broadcast('questions', @question.to_json)
    end
end