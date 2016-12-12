module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [ :vote, :re_vote ]
  end

  def vote
    @vote = Vote.new(value: params[:value], user: current_user, votable: @votable)

    if !current_user.author_of?(@votable)
      if @vote.save
        render json: { vote: @vote, rating: @votable.total_votes }
      else
        render text: "You already voted!", status: :unprocessable_entity
      end
    else
      render text: "You can't vote youself object", status: :unprocessable_entity
    end
  end

  def re_vote
    @vote = @votable.votes.first
    @votable.votes.where(user_id: current_user.id).destroy_all

    render json: { vote: @vote, rating: @votable.total_votes }
  end

  private

    def model_klass
      controller_name.classify.constantize
    end

    def set_votable
      @votable = model_klass.find(params[:id])
    end
end