require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user)  { create(:user) }
    let(:other) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, create(:comment, user: user), user: user }
    it { should_not be_able_to :destroy, create(:comment, user: other), user: user }

    it { should be_able_to :destroy,
         create(:attachment, attachable: create(:question, user: user)),
         user: user }
    it { should_not be_able_to :destroy,
         create(:attachment, attachable: create(:question, user: other)),
         user: user }

    it { should be_able_to :destroy,
         create(:attachment, attachable: create(:answer, user: user)),
         user: user }
    it { should_not be_able_to :destroy,
         create(:attachment, attachable: create(:answer, user: other)),
         user: user }

    it { should be_able_to :answer_best, create(:answer, question: create(:question, user: user)), user: user }
    it { should_not be_able_to :answer_best, create(:answer, question: create(:question, user: other)), user: user }

    describe "for voted" do
      %w(vote_up vote_down re_vote).each do |action|
        it { should be_able_to action.to_sym, create(:question, user: other), user: user }
        it { should be_able_to action.to_sym, create(:answer, user: other), user: user }
        it { should_not be_able_to action.to_sym, create(:question, user: user), user: user }
        it { should_not be_able_to action.to_sym, create(:answer, user: user), user: user }
      end
    end

    it { should be_able_to :create, Subscribtion }
    
    it { should be_able_to :destroy, create(:subscribtion, user: user), user: user }
    it { should_not be_able_to :destroy, create(:subscribtion, user: other), user: user }
  end
end