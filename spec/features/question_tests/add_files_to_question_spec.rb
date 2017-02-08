require "features_helper"

feature "Add files to question", %q{
  In order to show my question
  As author
  I wanna be able to add some files
} do
  given(:user)        { create(:user) }
  given(:question)    { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }
  
  background do
    log_in user
    visit new_question_path
  end

  scenario "User adds files to question",:pending, js: true do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    click_on "add"
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set("#{Rails.root}/spec/spec_helper.rb")
    click_on "Create"
 
    expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/3/spec_helper.rb"
  end

  scenario "remove files from question",js: true do
    visit question_path(question)
    click_on "del"

    expect(page).to have_no_link "README.md"
  end
end