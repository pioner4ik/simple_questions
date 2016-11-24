require 'features_helper'

feature "Edit question", %q{
  Autor,who create this question
  Can edit this question
  And other_user cant edit this question
} do
  given(:user)        { create(:user) }
  given(:other_user)  { create(:user) }
  given!(:question)    { create(:question, user: user) }

  describe "Authenticated user as author of question" do
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario "can see 'edit question' link" do
      
      expect(page).to have_link "Edit question"
    end


    scenario "try to edit question", js: true do
      click_on "Edit"

      within '.question' do
        fill_in "Title", with: "OtherTitle"
        fill_in "Body", with: "OtherText"
        click_on "Save"

        expect(page).to have_content "OtherTitle"
        expect(page).to have_content "OtherText"
        expect(page).to have_no_content question.title
        expect(page).to have_no_content question.body
        expect(page).to have_no_selector "textarea"
      end
    end
  end
 
  scenario "Other user can't view edit question button" do
    log_in(other_user)
    visit question_path(question)

    expect(page).to have_no_link "Edit question"
  end

  scenario "Non-authentication user can't view edit question button" do
    visit question_path(question)

    expect(page).to have_no_link "Edit question"
  end
end