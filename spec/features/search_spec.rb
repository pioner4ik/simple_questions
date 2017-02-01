require "features_helper"

feature 'search questions' do
  given!(:searched_questions)     { create_list(:question, 2, title: "Good question") }
  given!(:non_searched_questions) { create_list(:question, 2, title: "Bad question") }

  before do
    index
    visit root_path
    fill_in 'search', with: 'Good'
  end

  scenario "search questions as title 'Found'", :js do
    click_on 'Search'
    #save_and_open_page
    within '.search-result' do
      expect(page).to have_content("Good", count: 2)
      expect(page).to have_no_content("Bad")
    end
  end
end