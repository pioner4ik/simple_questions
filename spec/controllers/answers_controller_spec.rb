require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "POST #create" do
    sign_in_user

    let(:question) { create(:question, user_id: @user.id ) }

    context "with valid attributes" do
      it "should create new answer in db" do
        expect { process :create,
                 method: :post,
                 params: { answer: attributes_for(:answer), question_id: question }
                }.to change(question.answers, :count).by(1)
      end

      it "should redirect to question and show success message" do
        process :create, method: :post,
                params: { answer: attributes_for(:answer), question_id: question }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      it "should not change answers count in db" do
        expect { process :create,
                 method: :post,
                 params: { answer: attributes_for(:invalid_answer), question_id: question }
                }.to_not change(Answer, :count)
      end

      it "render action new and show error messages" do
        process :create, method: :delete,
                params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(flash[:error]).to be_present
      end
    end
  end
end
