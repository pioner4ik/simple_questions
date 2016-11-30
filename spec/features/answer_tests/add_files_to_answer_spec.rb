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

  scenario "User adds files to answer", js: true do
    fill_in "Your answer", with: "MyAnswer"
    attach_file 'File', "#{Rails.root}/config.ru"
    click_on "Create answer"

    within ".answers" do
      expect(page).to have_link "config.ru", href: "/uploads/attachment/file/1/config.ru"
    end
    #не прошел, думал дело в ссылке ,но нет.Прообовал так, все равно никак
    #  expect(page).to have_link "config.ru"
    #              Failure/Error: expect(page).to have_link "config.ru",
    #             href: "/uploads/attachment/file/1/config.ru"
    #             expected to find link "config.ru" with href "/uploads/attachment/file/1/config.ru"
    #             but there were no matches
  end

  scenario "remove files from answer",js: true do
    within ".answers" do
      click_on "del"
    
      expect(page).to have_no_link "README.md"
    end
  end
end
