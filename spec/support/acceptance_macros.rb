module AcceptanceMacros
  def log_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end
  
  def signup_user
    visit new_user_registration_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "123456", :match => :prefer_exact
    fill_in "Password confirmation", with: "123456", :match => :prefer_exact
    click_on "Sign up"
  end

  def create_question
    visit questions_path
    click_on "Ask question"
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    click_on "Create"
  end
end