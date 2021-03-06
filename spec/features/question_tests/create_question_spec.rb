require 'features_helper'

feature "Create question", %q{
  In order to get answer
  As registed user
  I want to be able to ask question
} do
  
  scenario "Authenticated user create question" do
    signup_user
    create_question
    
    expect(page).to have_content "Your question successfully created."
    expect(page).to have_content "Test question"
    expect(page).to have_content "Anybody"
  end

  scenario "Authenticated user create question with invalid attributes" do
    signup_user

    visit questions_path
    click_on "Ask question"
    fill_in "Title", with: ""
    fill_in "Body", with: ""
    click_on "Create"

    expect(page).to have_content "Titlecan't be blank"
    expect(page).to have_content "Bodycan't be blank"
  end

  scenario "Non-authenticated user create question" do
    visit questions_path

    expect(page).to have_no_content "Ask question"
  end

  context "mulitple sessions", :js, :pending do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        signup_user
        visit questions_path
      end
 
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on "Ask question"
        
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test text'
        click_on 'Create'
        
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end 
end