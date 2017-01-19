class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, except: :show
  authorize_resource class: Answer

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, each_serializer: AnswerSerializer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end

    def find_question
      @question = Question.find(params[:question_id])
    end
end