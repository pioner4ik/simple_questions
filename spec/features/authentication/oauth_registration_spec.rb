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

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_registration_path
      click_on "Sign in with Facebook"

      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end

  describe "Sign in as Vkontakte" do
    it "" do
      mock_auth_hash
      OmniAuth.config.add_mock(:vkontakte, {info: { :email => nil }} )
      visit new_user_registration_path
      click_on "Sign in with Vkontakte"

      expect(page).to have_content "Successfully authenticated from Vkontakte account."
      expect(page).to have_content "user1@test.com"
      expect(page).to have_link "Log out"
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_registration_path
      click_on "Sign in with Vkontakte"

      expect(page).to have_content('Could not authenticate you from Vkontakte')
    end
  end
end

