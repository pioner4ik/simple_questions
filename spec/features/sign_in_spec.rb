require 'rails_helper'

feature "User sign in" do
  scenario "Registed user try to sign in" do
    User.create(email: "user@test.ru", password: "123456")

    visit new_user_session_path
    fill_in "Email", with: "user@test.ru"
    fill_in "Password", with: "123456"
    click_on "Log in"

    expect(page).to have_content "Signed in successfully"
    expect(current_path).to eq root_path
  end

  scenario "Unregisted user try to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "unregisted_user@test.ru"
    fill_in "Password", with: "123456"
    click_on "Log in"

    expect(page).to have_content "Invalid Email or password."
    expect(current_path).to eq new_user_session_path
  end
end