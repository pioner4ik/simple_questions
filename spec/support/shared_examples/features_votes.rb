require "features_helper"

RSpec.shared_examples "votable author" do |model_name|
  # before action test need model-simple model name as string, user, any other_user is present
  describe "author can't vote #{model_name}", :js do
    
    before do
      log_in(user)
      visit question_path question
    end

    describe "vote up" do

      it "click 'up' not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-up").click
          expect(page).to have_content "0"
        end

        expect(page).to have_content "You can't vote"
      end
    end

    describe "vote down" do

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

RSpec.shared_examples "votable other users" do |model_name|
  describe "other users can vote #{model_name}", :js do

    before do
      log_in other_user
      visit question_path question
    end

    describe "vote up" do
      
      it "change vote by +1" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-up").click
          expect(page).to have_content "1"
        end
      end
    end

    describe "vote down" do
      
      it "change vote by -1" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-down").click
          expect(page).to have_content "-1"
        end
      end
    end

    describe "can't vote more than one time" do

      before do
        within ".#{model_name} .votes-table" do find(".fa-caret-up").click end
      end


      it "click link 'up' should not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-up").click
          expect(page).to have_content "1"
        end
      end 

      it "click link 'down' should not change #{model_name} votes" do
        within ".#{model_name} .votes-table" do 
          find(".fa-caret-down").click
          expect(page).to have_content "1"
        end
      end   
    end
  end
end

RSpec.shared_examples "votable unregisted" do |model_name|
  describe "non-authorized users can't vote", :js do

    before { visit question_path question }

    it "click link 'up' should not change #{model_name} votes" do
      within ".#{model_name} .votes-table" do 
        find(".fa-caret-up").click
        expect(page).to have_content "0"
      end
    end

    it "click link 'down' should not change #{model_name} votes" do
      within ".#{model_name} .votes-table" do 
        find(".fa-caret-down").click
        expect(page).to have_content "0"
      end
    end
  end
end

RSpec.shared_examples "re vote" do |model_name|
  describe "author can  re vote #{model_name}", :js do

    describe "click re vote" do
      before do
        log_in other_user
        visit question_path question
      end

      it "should delete last vote" do
        within ".#{model_name} .votes-table" do
          click_on "re vote"
          expect(page).to have_content "0"
        end
      end
    end

    describe "vote non-authors can't see 're vote' link" do
      
      describe "as Non-authorized user" do
        before do
          visit question_path question
        end

        it "'re vote' link not present" do
          expect(page).to have_no_link "re vote"
        end
      end

      describe "as non-author user" do
        before do
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



