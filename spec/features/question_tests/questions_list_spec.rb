require 'features_helper'

feature "Index page have a list of all questions" do
  let(:user) { create(:user) }
  before { create_list :question, 5, user_id: user.id }

  scenario "when you visit index path you should view all questions" do
    visit questions_path

    expect(page).to have_content "MyString", count: 5
  end 
end