require 'rails_helper'

feature "User sign in" do
  given(:user) { create(:user) }
  
  scenario "Registed user try to sign in" do
    log_in(user)

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

feature "User can registration in system" do
  scenario "With valid attributes" do
    signup_user
   
    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq root_path
  end

  scenario "With invalid attributes" do
    visit new_user_registration_path
    fill_in "Email", with: nil
    fill_in "Password", with: nil, :match => :prefer_exact
    fill_in "Password confirmation", with: nil, :match => :prefer_exact
    click_on "Sign up"

    expect(page).to have_content "Please review the problems below"
    expect(current_path).to eq user_registration_path
  end
end

feature "User can log out from system" do
  scenario "User click on button log out" do
    signup_user

    click_on "Log out"

    expect(page).to have_content "Signed out successfully."
    expect(current_path).to eq root_path
  end
end

feature "View  any button" do
  given(:user) { create(:user)}

  scenario "User dont view log out button unless signed in or registed" do
    visit root_path

    expect(page).to have_no_link "Log out"
    expect(page).to have_link "Sign in"
    expect(page).to have_link "New user?"
  end

  scenario "User must view sign in and sign out links unless signed in" do
    log_in(user)

    expect(page).to have_no_link "Sign in"
    expect(page).to have_no_link "New user?"
    expect(page).to have_link "Log out"
  end
end
