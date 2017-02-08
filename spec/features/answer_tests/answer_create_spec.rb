require 'features_helper'

feature "Create answer", %q{
Other authentication user
Can create answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question)   { create(:question, user: user) }
  given(:question_1) { create(:question, user: user) }

  scenario "Authentication user create answer", js: true do
    log_in(other_user)

    visit question_path(question)
    fill_in "Your answer", with: "My Answer"
    click_on "Create answer"

    within ".answers" do
      expect(page).to have_content "My Answer"
    end
  end

  scenario "Authentication user click on create with invalid attr", js: true do
    log_in(other_user)

    visit question_path(question)
    fill_in "Your answer", with: nil
    click_on "Create answer"

    expect(page).to have_content "Body can't be blank"
  end  

  scenario "Non-authentication user can't create answer", js: true do
    visit question_path(question)

    expect(page).to have_content "Please sign in to answer!"
    expect(page).to have_no_content "Create answer"
  end

  context "mulitple sessions", :js do
    scenario "answer appears on another user's page only for current question" do
      #########################################
      Capybara.using_session('user') do
        log_in(user)
        visit question_path question
      end
 
      Capybara.using_session('guest_1') do
        visit question_path question
      end

      Capybara.using_session('guest_2') do
        visit question_path question_1
      end
      ###########################################
      Capybara.using_session('user') do
        fill_in "Your answer", with: "Test Answer"
        click_on "Create answer"
        
        expect(page).to have_content "Test Answer"
      end

      Capybara.using_session('guest_1') do
        expect(page).to have_content "Test Answer"
      end

      Capybara.using_session('guest_2') do
        expect(page).to have_no_content "Test Answer"
      end
      ############################################
    end
  end 
end