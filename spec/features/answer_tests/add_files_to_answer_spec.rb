require "features_helper"

feature "Add files to answer", %q{
  In order to show my answer
  As author
  I wanna be able to add some files
} do
  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  before do
    log_in user
    visit question_path(question)
  end

  scenario "User adds files to answer", js: true do
    fill_in "Your answer", with: "MyAnswer"
    attach_file 'File', "#{Rails.root}/Rakefile"
    click_on "Create answer"

    within ".answers" do
      expect(page).to have_link "Rakefile", href: "/uploads/attachment/file/1/Rakefile"
    end
  end
end
