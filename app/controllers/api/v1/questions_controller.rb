class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource(class: Question)

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, each_serializer: QuestionSerializer
  end

  def create
    respond_with @question = Question.create(question_params)
  end

  private

    def question_params
      params.require(:question).permit(:title, :body)
    end
end