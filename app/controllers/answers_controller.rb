 class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, except: :create
  after_action  :publish_answer, only: :create

  respond_to :js

  include Voted
  
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def answer_best
    @question = @answer.question
    @answer.mark_answer_best
  end

  private
  
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [ :file, :_destroy ])
    end

    def publish_answer
      return if @answer.errors.any?
      
      ActionCable.server.broadcast("question-#{@answer.question.id}-answers", 
        { answer: @answer,
          attachments: @answer.attachments,
          author: @answer.user,
          rating: @answer.total_votes }.to_json
      )
    end
end
