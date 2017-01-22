class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :update, :destroy, :vote, :re_vote ]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  include Voted

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy  
    respond_with(@question.destroy)
  end

  private

    def set_question
      @question = Question.find(params[:id])
      gon.question_id = @question.id
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [ :id, :file, :_destroy ])
    end

    def build_answer
      @answer = @question.answers.build
    end

    def publish_question
      return if @question.errors.any?
      ActionCable.server.broadcast('questions', {
        question: @question,
        answers_count: @question.answers.count,
        votes_count: @question.votes.count,
        question_title: @question.title.capitalize}.to_json
        )
    end
end