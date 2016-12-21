require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  describe "POST #create" do

    describe "User is author " do
      let(:question)    { create(:question, user: @user) }
      let(:answer)      { create(:answer, user: @user, question: question) }
      
      context "create question comment" do
        
        it "create comment for question" do
           expect { process :create,
                   method: :post,
                   format: :js,
                   params: { comment: attributes_for(:comment), question_id: question.id }
                  }.to change(question.comments, :count).by(1)
        end
      end
      
      context "create answer comments" do

        it "create comment for answer" do
          expect { process :create,
                   method: :post,
                   format: :js,
                   params: { comment: attributes_for(:comment), answer_id: answer.id }
                   }.to change(answer.comments, :count).by(1)
        end
      end
    end

    describe "Other users" do
      let(:other_user)       { create(:user) }
      let(:other_question)   { create(:question, user: other_user) }
      let(:other_answer)     { create(:answer, user: other_user, question: other_question) }

      
      context "create question comment" do
        
        it "create comment for question" do
           expect { process :create,
                   method: :post,
                   format: :js,
                   params: { comment: attributes_for(:comment), question_id: other_question.id }
                  }.to change(other_question.comments, :count).by(1)
        end
      end
      
      context "create answer comments" do

        it "create comment for answer" do
          expect { process :create,
                   method: :post,
                   format: :js,
                   params: { comment: attributes_for(:comment), answer_id: other_answer.id }
                   }.to change(other_answer.comments, :count).by(1)
        end
      end
    end
  end
end
