require 'rails_helper'

feature "Create answer", %q{
Other authentication user
Can create answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question)   { create(:question, user: user) }

  scenario "Authentication user create answer", js: true do
    log_in(other_user)

    visit question_path(question)
    fill_in "Your answer", with: "My Answer"
    click_on "Create answer"

    #expect(page).to have_content "Congratulations! Answer created!"
    within ".answers" do
      expect(page).to have_content "My Answer"
    end
  end
=begin
  scenario "Authentication user click on create with invalid attr", js: true do
    log_in(other_user)

    visit question_path(question)
    fill_in "Your answer", with: nil
    click_on "Create answer"

    expect(page).to have_content "Answer is not created! Try later!"
    #expect(page).to have_content "Bodycan't be blank"
  end  
=end
  scenario "Non-authentication user can't create answer", js: true do
    visit question_path(question)

    expect(page).to have_content "Please sign in to answer!"
    expect(page).to have_no_content "Create answer"
  end
end