require 'rails_helper'

feature "Create answer", %q{
Other authentication user
Can create answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question)   { create(:question, user_id: user.id) }

  scenario "Authentication user create answer" do
    log_in(other_user)

    visit question_path(question)
    fill_in "Your answer", with: "My Answer"
    click_on "Create answer"

    expect(page).to have_content "Congratulations! Answer created!"
  end

  scenario "Authentication user just click button create answer" do
    log_in(other_user)

    visit question_path(question)
    click_on "Create answer"

    expect(page).to have_content "Answer is not created! Try later!"
  end

  scenario "Non-authentication user can't create answer" do
    visit question_path(question)
    fill_in "Your answer", with: "My Answer"
    click_on "Create answer"

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end
end