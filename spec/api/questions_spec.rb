require 'rails_helper'

describe 'Questions API' do
  describe 'GET/index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401  
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401  
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions)   { create_list(:question, 5) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'return questions list' do
        expect(response.body).to have_json_size(5).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|

        it "does contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context "answers" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|

          it "does contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET/show' do
    context 'unauthorized' do
      let!(:question) { create :question }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401  
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401  
      end
    end

    context 'authorized' do
      let(:access_token)  { create(:access_token) }
      let!(:question)     { create(:question) }
      let!(:attachments)  { create_list(:attachment, 5, attachable: question) }
      let!(:comments)     { create_list(:comment, 5, commentable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'return comments list' do
        expect(response.body).to have_json_size(5).at_path("question/comments")
      end

      it 'return attachments list' do
        expect(response.body).to have_json_size(5).at_path("question/attachments")
      end

      %w(id title body created_at updated_at).each do |attr|

        it "does contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end

  describe 'POST/create' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", format: :json
        expect(response.status).to eq 401  
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", format: :json, access_token: '1234'
        expect(response.status).to eq 401  
      end
    end

    context "authorized" do
      let(:access_token)  { create(:access_token) }

      context "with valid attributes" do
        before do
          post "/api/v1/questions", 
          params: { format: :json,
                    question: attributes_for(:question),
                    access_token: access_token.token }
        end

        it 'returns 201 status' do 
          expect(response.status).to eq 201
        end

        it 'return question is create' do
          expect(response.body).to have_json_path('question')
        end

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

        it 'returns 422 status' do 
          expect(response.status).to eq 422
        end

        it 'return false question create' do
          expect(response.body).to_not have_json_path('question')
        end

        it 'return errors' do
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end