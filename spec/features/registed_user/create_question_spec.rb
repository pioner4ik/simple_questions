require "rails_helper"

feature "Create question", %q{
  In order to get answer
  As registed user
  I want to be able to ask question
} do
  
  scenario "Authenticated user create question" do
    User.create(email: "user@test.ru", password: "123456")

    visit new_user_session_path
    fill_in "Email", with: "user@test.ru"
    fill_in "Password", with: "123456"
    click_on "Log in"

    visit question_path
    click_on "Ask question"
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    click on "Create"

    expect(page).to have_content "Your question successfully created."
  end
end