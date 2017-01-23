require 'rails_helper'

describe 'Answers API' do
  describe 'GET/index' do
    let!(:question) { create :question }

    it_behaves_like "API unauthorized/GET"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question)    { create(:question) }
      let!(:answers)     { create_list(:answer, 5, question: question) }
      let(:answer)       { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like "status 200"

      it_behaves_like "return list for(model, value, path)", "answers", 5, "answers"

      it_behaves_like "contains attributes", %w(id body created_at updated_at question_id) do
        let(:attributes_model) { answer }
        let(:path)             { "answers/0/" }
      end
    end
  end

  describe 'GET/show' do
    let!(:question) { create :question }

    it_behaves_like "API unauthorized/GET"
 

    context 'authorized' do
      let(:access_token)  { create(:access_token) }
      let!(:answer)       { create(:answer) }
      let!(:attachments)  { create_list(:attachment, 5, attachable: answer) }
      let!(:comments)     { create_list(:comment, 5, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }
      
      it_behaves_like "status 200"

      it_behaves_like "return list for(model, value, path)", "comments", 5, "answer/comments"

      it_behaves_like "return list for(model, value, path)", "attachments", 5, "answer/attachments"

      it_behaves_like "contains attributes", %w(id body created_at updated_at question_id) do
        let(:attributes_model) { answer }
        let(:path)             { "answer/" }
      end
    end
  end

  describe 'POST/create' do
    let!(:question) { create :question }

    it_behaves_like "API unauthorized/POST"

    context "authorized" do
      let(:access_token)  { create(:access_token) }

      context "with valid attributes" do
        
        before do
          post "/api/v1/questions/#{question.id}/answers", 
          params: { format: :json,
                    answer: attributes_for(:answer),
                    access_token: access_token.token }
        end

        it_behaves_like "status 201"

        it_behaves_like "model created", "answer"

        it "answer object contains body" do
          expect(response.body).to be_json_eql(attributes_for(:answer)[:body].to_json).at_path("answer/body")
        end
      end

      context "with invalid attributes" do
        before do
          post "/api/v1/questions", 
          params: { format: :json,
                    question: attributes_for(:invalid_question),
                    access_token: access_token.token }
        end

        it_behaves_like "status 422"

        it_behaves_like "model is not created", "answer"

        it_behaves_like "return errors"
      end
    end
  end

  def do_request(options= {})
    get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
  end
end