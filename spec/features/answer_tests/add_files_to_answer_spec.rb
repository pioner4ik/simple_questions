require "features_helper"

feature "Add some files to answer", %q{
  In order to show my answer
  As author
  I wanna be able to add some files
} do
  given(:user)        { create(:user) }
  given(:question)    { create(:question, user: user) }
  given(:answer)      { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  before do
    log_in user
    visit question_path(question)
  end
=begin
  scenario "User adds files to answer", js: true do
    fill_in "Your answer", with: "My Answer"
    #click_on "add"
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    #inputs[1].set("#{Rails.root}/spec/spec_helper.rb")
    click_on "Create answer"

    expect(page).to have_link "rails_helper.rb"#, href: "/uploads/attachment/file/2/rails_helper.rb"
    #expect(page).to have_link "spec_helper.rb"#, href: "/uploads/attachment/file/3/spec_helper.rb"
  end
=end
  scenario "remove files from answer",js: true do
    within ".answers" do
      click_on "del"
    
      expect(page).to have_no_link "README.md"
    end
  end
end
