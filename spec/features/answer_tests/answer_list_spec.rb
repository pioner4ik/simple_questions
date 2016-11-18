require 'rails_helper'

feature "Question page have a list of all answers" do
  let(:user)      { create(:user) }
  let(:question)  { create(:question, user_id: user.id) }
  
  before { create_list :answer, 10, question_id: question.id, user_id: user.id }

  scenario "when you visit question page you should view all answers" do
    visit question_path(question)

    expect(page).to have_content "AnswerText", count: 10
  end 
end