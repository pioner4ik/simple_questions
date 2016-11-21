require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "POST #create" do
    sign_in_user

    let(:question) { create(:question, user_id: @user.id ) }

    context "with valid attributes" do
      it "should create new answer in db" do
        expect { process :create,
                 method: :post,
                 format: :js,
                 params: { answer: attributes_for(:answer), question_id: question }
                }.to change(question.answers, :count).by(1)
      end

      it "should create new answer in db,with user who create it" do
        expect { process :create,
                 method: :post,
                 format: :js,
                 params: { answer: attributes_for(:answer), question_id: question }
                }.to change(@user.answers, :count).by(1)
      end

      it "should redirect to question and show success message" do
        process :create, method: :post, format: :js,
                params: { answer: attributes_for(:answer), question_id: question }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      it "should not change answers count in db" do
        expect { process :create,
                 method: :post,
                 format: :js,
                 params: { answer: attributes_for(:invalid_answer), question_id: question }
                }.to_not change(Answer, :count)
      end

      it "render action new and show error messages" do
        process :create, method: :post, format: :js,
                params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user


    context "User is author" do
      let(:question)   { create(:question, user_id: @user.id) }
      let(:answer)     { create(:answer, user_id: @user.id, question_id: question.id) }

      before { answer }

      it "should delete answer" do
        expect { process :destroy,
                 method: :delete,
                 format: :js,
                 params: { id: answer } 
                 }.to change(question.answers, :count).by(-1)
      end

      it "should render questions_path with valid message" do
        process :destroy, method: :delete, format: :js, params: { id: answer }

        expect(response).to redirect_to question_path(question)
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq "Answer deleted!"
      end
    end

    context "User is not author" do
      let(:other_user) { create(:user) }
      let(:question)   { create(:question, user_id: other_user.id) }
      let(:answer)     { create(:answer, user_id: other_user.id, question_id: question.id) }

      before { answer }

      it "other_user can't delete answer" do

        expect { process :destroy,
                 method: :delete,
                 format: :js,
                 params: { id: answer } 
                }.to_not change(Answer , :count)
      end

      it "should render questions_path with invalid message" do
        process :destroy, method: :delete, format: :js, params: { id: answer }

        expect(response).to redirect_to question_path(question)
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq "Answer is not deleted! Please sign in as author!"
      end
    end
  end
end
