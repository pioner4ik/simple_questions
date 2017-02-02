require "features_helper"

feature 'search questions' do
  let!(:user )          { create(:user, email: "goodemail@test.com") }
  let!(:other_user )    { create(:user, email: "bademail@test.com") }

  let!(:good_questions) { create_list(:question, 2, title: "good question", user: user) }
  let!(:bad_questions)  { create_list(:question, 2, title: "bad question", user: other_user) }

  let!(:good_answers)   { create_list(:answer, 2, body: "good answer", question: good_questions.first, user: user) }
  let!(:bad_answers)    { create_list(:answer, 2, body: "bad answer", question: good_questions.first, user: other_user) }
  
  let!(:good_comments)  { create_list(:comment, 2, content: "good comment", commentable: good_answers.first, user: user) }
  let!(:bad_comments)   { create_list(:comment, 2, content: "bad comment", commentable: good_answers.first, user: other_user) }

  before do
    index
    visit root_path
    fill_in 'search', with: 'good'
  end

  scenario "search all as title 'good'", :js do
    select 'all', from: 'category'
    click_on 'Search'

    within '.search-result' do
      expect(page).to have_content("Found 7 results")
      expect(page).to have_content("detected in questions", count: 2)
      expect(page).to have_content("detected in answers", count: 2)
      expect(page).to have_content("detected in comments", count: 2)
      expect(page).to have_content("detected in users")
      expect(page).to have_no_content("bad")
    end

  end

  scenario "search questions as 'good'", :js do
    select 'question', from: 'category'
    click_on 'Search'

    within '.search-result' do
      expect(page).to have_content("good question", count: 2)
      expect(page).to have_content("detected in questions", count: 2)
      expect(page).to have_no_content("bad")
    end
  end

  scenario "search answers as 'good'", :js do
    select 'answer', from: 'category'
    click_on 'Search'

    within '.search-result' do
      expect(page).to have_content("good answer", count: 2)
      expect(page).to have_content("detected in answers", count: 2)
      expect(page).to have_no_content("bad")
    end
  end

  scenario "search comments as 'good'", :js do
    select 'comment', from: 'category'
    click_on 'Search'

    within '.search-result' do
      expect(page).to have_content("good comment", count: 2)
      expect(page).to have_content("detected in comments", count: 2)
      expect(page).to have_no_content("bad")
    end
  end

  scenario "search user email as 'good'", :js do
    select 'user', from: 'category'
    click_on 'Search'

    within '.search-result' do
      expect(page).to have_content(user.email)
      expect(page).to have_content("detected in users")
      expect(page).to have_no_content(other_user.email)
    end
  end

  feature "to search any word,we write just 3 word" do
    before do
      index
      visit root_path
    end

    scenario "write 'que' to search any quetsions or que+", :js do
      fill_in 'search', with: 'que'
      select 'all', from: 'category'
      click_on 'Search'
      
      expect(page).to have_content("Found 4 results")
      within '.search-result' do
        expect(page).to have_content("question")
      end
    end

    scenario "write 'qu' print not found", :js do
      fill_in 'search', with: 'qu'
      select 'all', from: 'category'
      click_on 'Search'

      expect(page).to have_content("Search not found")
      within '.search-result' do
        expect(page).to have_no_content("question")
        expect(page).to have_no_content("answer")
        expect(page).to have_no_content("comment")
      end
    end
  end
end