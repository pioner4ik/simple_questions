module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [ :vote_up, :vote_down, :re_vote ]
    before_action :check_vote, only: [ :vote_up, :vote_down ]
    before_action :check_votable_owner, only: [ :vote_up, :vote_down ]
  end

  def vote_up
    @votable.vote_up(current_user)
    success_as_json
  end

  def vote_down
    @votable.vote_down(current_user)
    success_as_json
  end

  def re_vote
    @votable.reset_votes(current_user)
    success_as_json
  end

  private

    def model_klass
      controller_name.classify.constantize
    end

    def set_votable
      @votable = model_klass.find(params[:id])
      @name = model_klass.to_s.downcase
    end

    def success_as_json
      render json: { id: @votable.id, name: @name, rating: @votable.total_votes }
    end

    def check_votable_owner
      if current_user.author_of?(@votable)
        render json: { message: "You can't vote youself object"}, status: :unprocessable_entity
      end
    end

    def check_vote
      if @votable.check_vote_is_present(current_user)
        render json: { message: "You already voted!"}, status: :unprocessable_entity
      end
    end
end