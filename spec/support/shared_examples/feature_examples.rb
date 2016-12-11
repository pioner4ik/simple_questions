require "features_helper"

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
