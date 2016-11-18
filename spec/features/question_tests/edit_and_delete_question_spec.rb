require "rails_helper"

feature "Edit and delete buttons", %q{
  User,who create this question
  Can edit and delete this question
  And other_user cant view buttons
} do
  given(:user)        { create(:user) }
  given(:other_user)  { create(:user) }
  given(:question)    { create(:question, user_id: user.id) }

  scenario "This_user can view edit and delete buttons" do
    log_in(user)

    visit question_path(question)

    expect(page).to have_link "Edit question"
    expect(page).to have_link "Delete question"
  end

  scenario "Wnem user click delete button" do
    log_in(user)
    visit question_path(question)

    expect { click_on "Delete question" }.to change(user.questions, :count).by(-1)
  end
  
  scenario "Other user can't view edit and delete buttons" do
    log_in(other_user)

    visit question_path(question)

    expect(page).to have_no_link "Edit question"
    expect(page).to have_no_link "Delete question"
  end
end