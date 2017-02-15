require "features_helper"

RSpec.shared_examples "toogle view comments with click button" do |model_name|
  describe "comments button", :js do
    before do
      visit question_path(question_1)
      within ".#{model_name}" do
        click_on "View comments"
      end
    end

    it "show comments" do
      within ".#{model_name}" do
        expect(page).to have_link('Hide comments')
        expect(page).to have_no_link('View comments')

        within ".for-capybara-comments-test" do
          expect(page).to have_content('MyText', count: 3)
        end
      end
    end

    it "hide comments" do
      within ".#{model_name}" do
        click_on "Hide comments"
        
        expect(page).to have_link('View comments')
        expect(page).to have_no_link('Hide comments')
        
        within '.for-capybara-comments-test' do
          expect(page).to have_no_content('MyText')   
        end
      end
    end
  end
end

RSpec.shared_examples "commentable_user" do |model_name|
  describe "for authentication user", :js do
    before do
      log_in(user)
      visit question_path(question_1)
      within ".#{model_name}" do
        click_on "View comments"
      end
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

  describe "for non-authentication user " do
    scenario "can't add comment" do
      visit question_path(question_1)

      within ".#{model_name}" do
        expect(page).to have_no_selector('.comment-form')
      end
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
          click_on "View comments"
          find("textarea#comment_content").set("new comment")
          click_on "send comment"
        end

        expect(page).to have_content "new comment"
      end

      Capybara.using_session('guest_1') do
        within ".#{model_name}" do click_on "View comments" end
        expect(page).to have_content "new comment"
      end

      Capybara.using_session('guest_2') do
        expect(page).to have_no_content "new comment"
      end
      ############################################
    end
  end 
end