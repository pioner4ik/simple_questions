require "rails_helper"

RSpec.shared_examples "voted" do
  # before test you need add 2 lets(models with attributes as author - author_model
  # and model with attributes as any other user - user_model ), also need check author
  # signed in 
  context "as user" do
    describe 'POST #vote_up' do  

      it 'add vote up' do
        expect { process :vote_up,
                 method: :post,
                 params: { id: user_model } }.to change(user_model.votes, :count).by(1)
      end
    end

    describe 'POST #vote_down' do  

      it 'add vote down' do
        expect { process :vote_down,
                 method: :post,
                 params: { id: user_model } }.to change(user_model.votes, :count).by(1)
      end
    end

    describe 'POST#re_vote' do
      let!(:vote) { create(:vote, votable: user_model, user: @user) }

      it 'user can re vote' do
        expect { process :re_vote,
                 method: :post,
                 params: { id: user_model } }.to change(user_model.votes, :count).by(-1)
      end
    end
  end

  context "as author" do
    describe 'POST #vote_up' do  

      it 'can not add vote up' do
        expect { process :vote_up,
                 method: :post,
                 params: { id: author_model } }.to_not change(author_model.votes, :count)
      end
    end

    describe 'POST #vote_down' do  

      it 'can not add vote down' do
        expect { process :vote_down,
                 method: :post,
                 params: { id: author_model } }.to_not change(author_model.votes, :count)
      end
    end
  end
end