require "features_helper"

feature "Add files to question", %q{
  In order to show my question
  As author
  I wanna be able to add some files
} do
  given(:user) { create(:user) }
  given!(:question)    { create(:question, user: user) }
  given!(:attachment)  { create(:attachment, attachable: question) }
  
  before do
    log_in user
    visit new_question_path
  end

  scenario "User adds files to question" do
    
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    within ".short_attachments" do
      click_on "add"
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/README.md")
      inputs[1].set("#{Rails.root}/Gemfile")
    end
    click_on "Create"


    expect(page).to have_link "README.md", href: "/uploads/attachment/file/1/README.md"
    expect(page).to have_link "Gemfile", href: "/uploads/attachment/file/2/Gemfile"
    #не проходит undefined method `set' for nil:NilClass

  end

  scenario "remove files from question",js: true do
    visit question_path(question)
    click_on "del"

    expect(page).to have_no_link "README.md"
  end
end