require 'features_helper'

feature "Answer editing", %q{
  In order to fix mistake
  As an author of answer
  I wanna be able to edit answer
  } do

  given(:user)       { create :user }
  given(:other_user) { create :user }
  given!(:question)  { create :question, user_id: user.id }
  given!(:answer)    { create :answer, question_id: question.id, user_id: user.id }

  scenario "Non-authenticated user try to edit answer" do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user as author of answer" do
    before do
      log_in user
      visit question_path(question)
    end

    scenario "try to edit answer", js: true do
      click_on "Edit"

      within '.answer' do
        fill_in "Body", with: "OtherAnswerText"
        click_on "Save"

        expect(page).to have_content "OtherAnswerText"
        expect(page).to have_no_content answer.body
        expect(page).to have_no_selector "textarea"
      end
    end
  end

  describe "Authenticated user as non-author of answer" do
    before do
      log_in other_user
      visit question_path(question)
    end

    scenario "can't see 'edit' link" do
      expect(page).to_not have_link "Edit"
    end
  end
end