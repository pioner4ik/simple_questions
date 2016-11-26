require 'features_helper'

feature "Create question", %q{
  In order to get answer
  As registed user
  I want to be able to ask question
} do
  
  scenario "Authenticated user create question" do
    signup_user

    visit questions_path
    click_on "Ask question"
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    click_on "Create"

    expect(page).to have_content "Your question successfully created."
    expect(page).to have_content "Test question"
    expect(page).to have_content "Anybody"
  end

  scenario "Authenticated user create question with invalid attributes" do
    signup_user

    visit questions_path
    click_on "Ask question"
    fill_in "Title", with: ""
    fill_in "Body", with: ""
    click_on "Create"

    expect(page).to have_content "Titlecan't be blank"
    expect(page).to have_content "Bodycan't be blank"
    expect(page).to have_content "Error! Try later"
  end

  scenario "Non-authenticated user create question" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end