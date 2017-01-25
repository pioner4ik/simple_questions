require 'features_helper'

feature "Add comment to question", %q{
Users can add comment to answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question_1) { create(:question, user: user) }
  given!(:question_2) { create(:question, user: user) }

  it_behaves_like "commentable_user", "question"
  it_behaves_like "commentable_multiple_sessions", "question"
end