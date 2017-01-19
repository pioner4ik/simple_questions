require 'rails_helper'

describe 'Answers API' do
  describe 'GET/index' do
    let!(:question) { create :question }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401  
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401  
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question)    { create(:question) }
      let!(:answers)     { create_list(:answer, 5, question: question) }
      let(:answer)       { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'return amswers list' do
        expect(response.body).to have_json_size(5).at_path("answers")
      end

      %w(id body created_at updated_at question_id).each do |attr|

        it "does contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
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
      let!(:answer)       { create(:answer) }
      let!(:attachments)  { create_list(:attachment, 5, attachable: answer) }
      let!(:comments)     { create_list(:comment, 5, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'return comments list' do
        expect(response.body).to have_json_size(5).at_path("answer/comments")
      end

      it 'return attachments list' do
        expect(response.body).to have_json_size(5).at_path("answer/attachments")
      end

      %w(id body created_at updated_at question_id).each do |attr|

        it "does contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end

  describe 'POST/create' do
    let!(:question) { create :question }

    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401  
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401  
      end
    end

    context "authorized" do
      let(:access_token)  { create(:access_token) }

      context "with valid attributes" do
        
        before do
          post "/api/v1/questions/#{question.id}/answers", 
          params: { format: :json,
                    answer: attributes_for(:answer),
                    access_token: access_token.token }
        end

        it 'returns 201 status' do 
          expect(response.status).to eq 201
        end

        it 'return answer is create' do
          expect(response.body).to have_json_path('answer')
        end

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

        it 'returns 422 status' do 
          expect(response.status).to eq 422
        end

        it 'return false answer create' do
          expect(response.body).to_not have_json_path('answer')
        end

        it 'return errors' do
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end