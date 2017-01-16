require 'features_helper'

feature "Social network registration" do

  context "Success authentication" do
    it "Email is present" do
      mock_auth_hash
      OmniAuth.config.add_mock(:facebook, {info: { :email => 'test@gmail.com' }} )
      visit new_user_registration_path
      click_on "Sign in with Facebook"
      

      expect(page).to have_content "Successfully authenticated from Facebook account."
      expect(page).to have_content "test@gmail.com"
      expect(page).to have_link "Log out"
    end

    context "Email not present" do
      it "user give it" do
        mock_auth_hash
        OmniAuth.config.add_mock(:facebook, {info: { :email => nil }} )
        visit new_user_registration_path
        click_on "Sign in with Facebook"
        fill_in "Email", with: "test_user@email.com"
        click_on "Email vertification"

        expect(page).to have_content "Successfully authenticated from Facebook account."
        expect(page).to have_content "test_user@email.com"
        expect(page).to have_link "Log out"
      end

      it "user not give it" do
        mock_auth_hash
        OmniAuth.config.add_mock(:facebook, {info: { :email => nil }} )
        visit new_user_registration_path
        click_on "Sign in with Vkontakte"
        fill_in "Email", with: nil
        click_on "Email vertification"

        expect(page).to have_content "Email is empty!"
        expect(current_path).to eq new_user_path
      end
    end
  end
end



