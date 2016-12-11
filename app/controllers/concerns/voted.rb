module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [ :vote, :re_vote ]
  end

  def vote
    @vote = Vote.new(value: params[:value], user: current_user, votable: @votable)

    if !current_user.author_of?(@votable)
      respond_to do |format|
        if @vote.save
          format.json { render json: { vote: @vote, rating: @votable.total_votes } }
        else
          format.json { render html: "You already voted! Push button 're vote' to change vote", status: :unprocessable_entity  }
        end
      end

    else
      respond_to do |format|
        format.json { render html: "You can't vote youself object", status: :unprocessable_entity  }
      end
    end
  end

  def re_vote
    @vote = @votable.votes.first
    @votable.votes.where(user_id: current_user.id).destroy_all

    respond_to do |format|
      format.json { render json: { vote: @vote, rating: @votable.total_votes } }
    end
  end

  private

    def model_klass
      controller_name.classify.constantize
    end

    def set_votable
      @votable = model_klass.find(params[:id])
    end
end