require 'features_helper'

feature "Click on 'make best' button make answer best" do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  let(:question)    { create(:question, user_id: user.id) }
  let!(:answer)     { create(:answer, user: user, question: question) }
  
  scenario "when author of question click 'make best',this answer mark as best", js: true do
    log_in user
    visit question_path(question)
    click_on 'make best'

    within "#answer-#{answer.id}" do
      expect(page).to have_content answer.body
      expect(page).to have_selector '.fa-check'
      expect(page).to have_no_link "make best"
    end    
  end

  describe "when user is non-author of question" do
    let!(:best_answer) { create(:answer, user: user, question: question, best: true) }
  
    scenario "he can't mark answer", js: true do
      log_in other_user
      visit question_path(question)

      expect(page).to have_selector '.fa-check'
      expect(page).to have_no_link "make best"
    end
  end
end