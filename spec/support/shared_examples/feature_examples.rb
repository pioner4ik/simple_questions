require "features_helper"
#Rspec просит добавить в rails_helper строчку
#Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
#при ее добавлении происходит конфликт при прогоне всех тестов
#если прогнать тесты по отдельным папками controllers feautures models
#то все проходит
RSpec.shared_examples "votable author" do |model_name|

  before do
    log_in user
    visit question_path question
  end

  describe "Author,can't vote #{model_name}" do
    describe "Author vote up #{model_name}", :js do

      it "click 'up' not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-up").click
          expect(page).to have_content "0"
        end

        expect(page).to have_content "You can't vote"
      end
    end

    describe "Author vote down #{model_name}", :js do

      it "click 'down' not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-down").click
          expect(page).to have_content "0"
        end

        expect(page).to have_content "You can't vote"
      end
    end
  end
end

RSpec.shared_examples "votable others" do |model_name|
  describe "Other users can vote #{model_name}" do

    before do
      log_in other_user
      visit question_path question
    end

    describe "vote up", :js do
      
      it "should change vote by +1" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-up").click
          expect(page).to have_content "1"
        end
      end
    end

    describe "vote down", :js do
      
      it "should change vote by -1" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-down").click
          expect(page).to have_content "-1"
        end
      end
    end

    describe "Other users can't vote more than one time", :js do

      before do
        within ".#{model_name} .votes-table" do find(".fa-caret-up").click end
      end

      it "click link 'up' should not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-up").click
          expect(page).to have_content "1"
        end

        #expect(page).to have_content "You already voted!"
      end

      it "click link 'down' should not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-down").click
          expect(page).to have_content "1"
        end

        expect(page).to have_content "You already voted!"
      end   
    end
  end
end

RSpec.shared_examples "votable unregisted" do |model_name|
  describe "Non-authorized users can't vote", :js do

    before { visit question_path question }

    it "click link 'up' should not change #{model_name} votes" do
      within ".#{model_name} .votes-table" do 
        find(".fa-caret-up").click
        expect(page).to have_content "0"
      end

      expect(page).to have_content "You need to sign in"
    end

    it "click link 'down' should not change #{model_name} votes" do
      within ".#{model_name} .votes-table" do 
        find(".fa-caret-down").click
        expect(page).to have_content "0"
      end

      expect(page).to have_content "You need to sign in"
    end
  end
end

RSpec.shared_examples "re vote" do |model_name|
  describe "Other users can vote #{model_name}", :js do

    background do
      log_in other_user
      visit question_path question
      within ".#{model_name} .votes-table" do find(".fa-caret-up").click end
    end

    describe "click re vote" do
      
      it "should delete last vote" do
        within ".#{model_name} .votes-table" do
          find(".re-vote").click
          expect(page).to have_content "0" # этот не прошел
        end
      end
    end

    describe "non-authors of vote can't see 're vote' link" do
      
      describe "as Non-authorized user" do
        before do
          click_on "Log out"
          visit question_path question
        end

        it "'re vote' link not present" do
          expect(page).to have_no_link "re vote"
        end
      end

      describe "as non-author user" do
        before do
          click_on "Log out"
          log_in user
          visit question_path question
        end

        it "'re vote' link not present" do
          expect(page).to have_no_link "re vote"
        end
      end
    end
  end
end



