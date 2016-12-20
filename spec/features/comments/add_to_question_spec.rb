require 'features_helper'

feature "Add comment to question", %q{
Users can add comment to answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question_1) { create(:question, user: user) }
  given(:question_2) { create(:question, user: user) }

  scenario "Authentication user add comment", :js do
    log_in(user)
    visit question_path(question_1)
    find("textarea#comment_content").set("new comment")
    click_on "send comment"

    expect(page).to have_content "new comment"
  end

  scenario "Authentication user add comment with invalid attr", :js do
    log_in(user)
    visit question_path(question_1)
    find("textarea#comment_content").set("")
    click_on "send comment"

    expect(page).to have_no_content "new comment"
  end

  scenario "Other user add comment", :js do
    log_in(other_user)
    visit question_path(question_1)
    find("textarea#comment_content").set("new comment")
    click_on "send comment"

    expect(page).to have_content "new comment"
  end

  scenario "Non-authentication user can't add comment", :js do
    visit question_path(question_1)
    find("textarea#comment_content").set("new comment")
    click_on "send comment"

    expect(page).to have_no_content "new comment"
  end

  context "mulitple sessions", :js do
    scenario "comments appears on another user's page only for current question" do
      #########################################
      Capybara.using_session('user') do
        log_in(user)
        visit question_path question_1
      end
 
      Capybara.using_session('guest_1') do
        log_in(other_user)
        visit question_path question_1
      end

      Capybara.using_session('guest_2') do
        visit question_path question_2
      end
      ###########################################
      Capybara.using_session('user') do
        find("textarea#comment_content").set("new comment")
        click_on "send comment"

        expect(page).to have_content "new comment"
      end

      Capybara.using_session('guest_1') do
        expect(page).to have_content "new comment"
      end

      Capybara.using_session('guest_2') do
        expect(page).to have_no_content "new comment"
      end
      ############################################
    end
  end 
end