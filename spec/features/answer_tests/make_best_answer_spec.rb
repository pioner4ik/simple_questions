require 'features_helper'

feature "Click on 'make best' button make answer best and replase it on top" do
  let(:user)      { create(:user) }
  let(:question)  { create(:question, user_id: user.id) }
  let!(:answer)    { create(:answer, user: user, question: question) }
  
  scenario "when you click 'make best',this answer mark as best", js: true do
    log_in user
    visit question_path(question)
    click_on 'make best'

    within "#best-answer" do
      expect(page).to have_content answer.body
      expect(page).to have_content "Best answer"
      expect(page).to have_no_link "make best"
    end    
  end 
end