require "features_helper"

feature "votable answer" do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  let(:question)    { create(:question, user: user) }

  it_behaves_like "votable author", "question"
  
  it_behaves_like "votable other users", "question"
  
  it_behaves_like "votable unregisted", "question"
  
  it_behaves_like "re vote", "question" do
    let!(:vote) { create(:vote, votable: question, user: other_user) }
  end
end
