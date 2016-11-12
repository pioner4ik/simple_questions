require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:params) do
    { answer: attributes_for(:answer), question_id: question }
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "should create new answer in db" do
        expect { process :create,
                 method: :post,
                 params: params
                }.to change( question.answers, :count).by(1)
      end

      it "should redirect to question and show success message" do
        process :create, method: :post, params: params
        expect(response).to redirect_to question_path(assigns(:question))
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

      it "render actin new and show error messages" do
        process :create, method: :delete,
                params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end
  end
end
