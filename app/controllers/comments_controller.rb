class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action  :publish_comment, only: :create
 
  def create
    @comment = Comment.create(comment_params.merge(user_id: current_user.id, commentable: @commentable))
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_commentable
      klass = [Question, Answer].detect { |model| params["#{model.name.underscore}_id"] }
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end

    def channel_id
        @commentable.is_a?(Question) ? @commentable.id : @commentable.question_id
    end

    def publish_comment
      return if @comment.errors.any?
      
      ActionCable.server.broadcast("question-#{channel_id}-comments", @comment.to_json)
    end
end
