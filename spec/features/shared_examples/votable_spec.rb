require "features_helper"
=begin
shared_examples "votable" do |model_name|

  before do
    sign_in user
    visit question_path question
  end

  describe "Author,can't vote #{model_name}", js: true do
    context "Author can't vote her #{model_name}" do

      it "click 'up' not change #{model_name} votes"
        within ".#{model_name}" { find(".fa-caret-up").click }
        expect(page).to have_content "0"
      end

      it "click 'down' not change #{model_name} votes"
        within ".#{model_name}" { find(".fa-caret-down").click }
        expect(page).to have_content "0"
      end
    end
  end

  describe "Other users can vote #{model_name}", js: true do
    let!()

    context "Other users can vote other #{model_name}" do
      
      it "should change vote by +1"
        within ".#{model_name}" { find(".fa-caret-up").click }
        expect(page).to have_content "1"
      end

      it "should change vote by 1"
        within ".#{model_name}" { find(".fa-caret-down").click }
        expect(page).to have_content "-1"
      end
    end

    describe "Other users can't vote more than one time" do
      before do
        within ".#{model_name}" { find(".fa-caret-up").click }
      end

      it "click link 'up' should not change #{model_name} votes"
        within ".#{model_name}" { find(".fa-caret-up").click }
        expect(page).to have_content "1"
      end

      it "click link 'down' should not change #{model_name} votes"
        within ".#{model_name}" { find(".fa-caret-down").click }
        expect(page).to have_content "1"
      end   
    end
  end

  describe "Non-authorized users can't vote", js: true do
    before do
      within ".#{model_name}" { find(".fa-caret-up").click }
      log_out
      visit question_path question
    end

    context "can't vote" do

      it "click link 'up' should not change #{model_name} votes"
        within ".#{model_name}" { find(".fa-caret-up").click }
        expect(page).to have_content "1"
      end

      it "click link 'down' should not change #{model_name} votes"
        within ".#{model_name}" { find(".fa-caret-down").click }
        expect(page).to have_content "1"
      end
    end
  end
end
=end