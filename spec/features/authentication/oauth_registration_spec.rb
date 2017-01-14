require 'features_helper'

feature "Social network registration" do

  describe "Sign in as Facebook" do
    it "Success authentication" do
      mock_auth_hash
      OmniAuth.config.add_mock(:facebook, {info: { :email => 'test@gmail.com' }} )
      visit new_user_registration_path
      click_on "Sign in with Facebook"
      

      expect(page).to have_content "Successfully authenticated from Facebook account."
      expect(page).to have_content "test@gmail.com"
      expect(page).to have_link "Log out"
    end

    it "Email not present" do
      mock_auth_hash
      OmniAuth.config.add_mock(:facebook, {info: { :email => nil }} )
      visit new_user_registration_path
      click_on "Sign in with Facebook"

      expect(page).to have_content "Please enter your email to finish registration"
      expect(current_path).to eq new_user_path
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_registration_path
      click_on "Sign in with Facebook"

      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end

  describe "Sign in as Vkontakte" do
    it "Success authentication" do
      mock_auth_hash
      OmniAuth.config.add_mock(:vkontakte, {info: { :email => nil }} )
      visit new_user_registration_path
      click_on "Sign in with Vkontakte"
      fill_in "Email", with: "test_user@email.com"
      click_on "Email vertification"

      expect(page).to have_content "Successfully authenticated from Vkontakte account."
      expect(page).to have_content "test_user@email.com"
      expect(page).to have_link "Log out"
    end

    it "Email not present" do
      mock_auth_hash
      OmniAuth.config.add_mock(:vkontakte, {info: { :email => nil }} )
      visit new_user_registration_path
      click_on "Sign in with Vkontakte"
      fill_in "Email", with: nil
      click_on "Email vertification"

      expect(page).to have_content "Email is empty!"
      expect(current_path).to eq new_user_path
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_registration_path
      click_on "Sign in with Vkontakte"

      expect(page).to have_content('Could not authenticate you from Vkontakte')
    end
  end
end

