require "rails_helper"

RSpec.shared_examples "votable" do 
  describe 'create vote' do

    it 'saves new vote in database' do
      expect { process :vote,
               method: :post,
               format: :json,
               params: { vote: attributes_for(:vote), votable: model_name, user: @user }
             }.to change(model_name.votes, :count).by(1)#тут пишет no routes matches
    end
  end

  describe 'create vote' do
    let!(:vote) { create(:vote, user: @user, votable: model_name) }

    it 'saves new vote in database' do
      expect { process :re_vote,
               method: :delete,
               format: :json,
               params: { votable: model_name ,user: @user }
             }.to change(model_name.votes, :count).by(-1)#тут пишет no routes matches
    end
  end
end