require 'rails_helper'

describe 'Profile API' do
  describe 'GET/me' do

    it_behaves_like "API unauthorized/GET"

    context 'authorized' do
      let(:me)            { create :user }
      let(:access_token)  { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it_behaves_like "status 200"

      it_behaves_like "contains attributes", %w(email id created_at updated_at admin) do
        let(:attributes_model) { me }
        let(:path)             { "" }
      end

      it_behaves_like "does not contains attributes", %w(password encrypted_password)
    end
  end

  describe 'GET/index' do
    
    it_behaves_like "API unauthorized/GET"

    context 'authorized' do
      let(:me)            { create :user }
      let!(:users)        { create_list(:user, 5) }
      let(:access_token)  { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it_behaves_like "status 200"

      it_behaves_like "return list for(model, value, path)", "users", 5

      it "does not contains current user" do
        expect(response.body).to_not include_json(me.to_json)
      end

      it_behaves_like "contains attributes", %w(email id created_at updated_at admin) do
        let(:attributes_model) { users.first }
        let(:path)             { "0/" }
      end
      
      it_behaves_like "does not contains attributes", %w(password encrypted_password)
    end
  end

  def do_request(options= {})
    get '/api/v1/profiles/me', { format: :json }.merge(options)
  end
end