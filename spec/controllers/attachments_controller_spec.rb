require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user

  describe "DELETE #destroy" do

    describe "User is author " do
      let(:question)    { create(:question, user: @user) }
      let(:answer)      { create(:answer, user: @user, question: question) }
      
      context "delete question file" do
        let!(:attachment) { create(:attachment, attachable: question) }

        it "should delete question files" do
          expect { process :destroy,
                   method: :delete,
                   format: :js,
                   params: { id: attachment } 
                   }.to change(question.attachments, :count).by(-1)
        end
      end
      
      context "delete answer file" do
        let!(:attachment) { create(:attachment, attachable: answer) }

        it "should delete answer files" do
          expect { process :destroy,
                   method: :delete,
                   format: :js,
                   params: { id: attachment } 
                   }.to change(answer.attachments, :count).by(-1)
        end
      end
    end

    describe "User is not author" do
      let(:other_user)       { create(:user) }
      let(:other_question)   { create(:question, user: other_user) }
      let(:other_answer)     { create(:answer, user: other_user, question: other_question) }

      
      context "he can't delete question file" do
        let!(:attachment) { create(:attachment, attachable: other_question) }

        it "other_user can't delete answer" do

          expect { process :destroy,
                   method: :delete,
                   format: :js,
                   params: { id: attachment } 
                  }.to_not change(Attachment , :count)
        end
      end

      context "he can't delete answer file" do
        let!(:attachment) { create(:attachment, attachable: other_answer) }

        it "other_user can't delete answer" do

          expect { process :destroy,
                   method: :delete,
                   format: :js,
                   params: { id: attachment } 
                  }.to_not change(Attachment , :count)
        end
      end
    end
  end
end
