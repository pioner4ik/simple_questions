require "features_helper"

feature "Add files to answer", %q{
  In order to show my answer
  As author
  I wanna be able to add some files
} do
  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  before do
    log_in user
    visit new_question_path
  end

  scenario "User adds files to answer" do
    fill_in "Body", with: "MyAnswer"
    attach_file 'File', "#{Rails.root}/README.md"
    click_on "Create"

    within ".answers" do
      expect(page).to have_link "README.md", href: "/uploads/attachment/file/1/README.md"
    end
  end
end
