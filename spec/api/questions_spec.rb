require 'rails_helper'

describe 'Questions API' do
  describe 'GET/index' do

    it_behaves_like "API unauthorized/GET"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions)   { create_list(:question, 5) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like "status 200"

      it_behaves_like "return list for(model, value, path)", "questions", 5, "questions"

      it_behaves_like "contains attributes", %w(id title body created_at updated_at) do
        let(:attributes_model) { question }
        let(:path)             { "questions/0/" }
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context "answers" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        it_behaves_like "contains attributes", %w(id body created_at updated_at) do
          let(:attributes_model) { answer }
          let(:path)             { "questions/0/answers/0/" }
        end
      end
    end
  end

  describe 'GET/show' do

    it_behaves_like "API unauthorized/GET"

    context 'authorized' do
      let(:access_token)  { create(:access_token) }
      let!(:question)     { create(:question) }
      let!(:attachments)  { create_list(:attachment, 5, attachable: question) }
      let!(:comments)     { create_list(:comment, 5, commentable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it_behaves_like "status 200"

      it_behaves_like "return list for(model, value, path)", "comments", 5, "question/comments"

      it_behaves_like "return list for(model, value, path)", "attachments", 5, "question/attachments"

      it_behaves_like "contains attributes", %w(id title body created_at updated_at) do
        let(:attributes_model) { question }
        let(:path)             { "question/" }
      end
    end
  end

  describe 'POST/create' do

    it_behaves_like "API unauthorized/POST"

    context "authorized" do
      let(:access_token)  { create(:access_token) }

      context "with valid attributes" do
        before do
          post "/api/v1/questions", 
          params: { format: :json,
                    question: attributes_for(:question),
                    access_token: access_token.token }
        end

        it_behaves_like "status 201"

        it_behaves_like "model created", "question"

        %w(title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(attributes_for(:question)[attr.to_sym].to_json).at_path("question/#{attr}")
          end
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

        it_behaves_like "model is not created", "question"

        it_behaves_like "return errors"
      end
    end
  end

  def do_request(options= {})
    get '/api/v1/questions', { format: :json }.merge(options)
  end
end