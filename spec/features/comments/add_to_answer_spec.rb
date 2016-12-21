require 'features_helper'

feature "Add comment to answer", %q{
Users can add comment to answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question_1) { create(:question, user: user) }
  given(:question_2) { create(:question, user: user) }
  given!(:answer)    { create(:answer, user: user, question: question_1) }

  scenario "Authentication user add comment", :js do
    log_in(user)
    visit question_path(question_1)

    within '.answers' do
      find("textarea#comment_content").set("new comment")
      click_on "send comment"

      expect(page).to have_content "new comment"
    end
  end

  scenario "Authentication user add comment with invalid attr", :js do
    log_in(user)
    visit question_path(question_1)

    within '.answers' do
      find("textarea#comment_content").set("")
      click_on "send comment"

      expect(page).to have_no_content "new comment"
    end
  end

  scenario "Other user add comment", :js do
    log_in(other_user)
    visit question_path(question_1)

    within '.answers' do
      find("textarea#comment_content").set("new comment")
      click_on "send comment"

      expect(page).to have_content "new comment"
    end
  end

  scenario "Non-authentication user can't add comment", :js do
    visit question_path(question_1)

    within '.answers' do
      find("textarea#comment_content").set("new comment")
      click_on "send comment"

      expect(page).to have_no_content "new comment"
    end
  end

  context "mulitple sessions", :js do
    scenario "comments appears on another user's page only for current question answers" do
      #########################################
      Capybara.using_session('user') do
        log_in(user)
        visit question_path question_1
      end
 
      Capybara.using_session('guest_1') do
        visit question_path question_1
      end

      Capybara.using_session('guest_2') do
        log_in(other_user)
        visit question_path question_2
      end
      ###########################################
      Capybara.using_session('user') do
        within '.answers' do
          find("textarea#comment_content").set("new comment")
          click_on "send comment"

          expect(page).to have_content "new comment"
        end
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