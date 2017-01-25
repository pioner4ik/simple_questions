require "features_helper"

feature "votable question" do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  let!(:question)   { create(:question, user: user) }
  let!(:answer)     { create(:answer, question: question, user: user) }

  it_behaves_like "votable author", "answer"

  it_behaves_like "votable other users", "answer"

  it_behaves_like "votable unregisted", "answer"

  it_behaves_like "re vote", "answer" do
    let!(:vote) { create(:vote, votable: answer, user: other_user) }
  end
end