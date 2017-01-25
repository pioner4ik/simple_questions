require 'features_helper'

feature "Add comment to answer", %q{
Users can add comment to answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question_1) { create(:question, user: user) }
  given(:question_2) { create(:question, user: user) }
  given!(:answer)    { create(:answer, user: user, question: question_1) }

  it_behaves_like "commentable_user", "answer"
  it_behaves_like "commentable_multiple_sessions", "answer"
end