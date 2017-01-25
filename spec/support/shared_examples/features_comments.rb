require "features_helper"

RSpec.shared_examples "commentable_user" do |model_name|
  describe "for authentication user", :js do
    before do
      log_in(user)
      visit question_path(question_1)
    end

    scenario "author add comment" do
      within ".#{model_name}" do
        find("textarea#comment_content").set("New comment")
        click_on "send comment"
      end

      expect(page).to have_content "New comment"
    end

    scenario "author comment with invalid attr" do
      within ".#{model_name}" do
        find("textarea#comment_content").set("")
        click_on "send comment"
      end

      expect(page).to have_no_content "new comment"
    end

    scenario "user add comment" do
      within ".#{model_name}" do
        find("textarea#comment_content").set("new comment")
        click_on "send comment"
      end

      expect(page).to have_content "new comment"
    end
  end

  describe "for non-authentication user ", :js do
    scenario "can't add comment" do
      visit question_path(question_1)
      within ".#{model_name}" do
        find("textarea#comment_content").set("new comment")
        click_on "send comment"
      end

      expect(page).to have_no_content "new comment"
    end
  end
end

RSpec.shared_examples "commentable_multiple_sessions" do |model_name|
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
        within ".#{model_name}" do
          find("textarea#comment_content").set("new comment")
          click_on "send comment"
        end

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

