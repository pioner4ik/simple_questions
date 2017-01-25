require "rails_helper"

RSpec.shared_examples "API unauthorized/GET" do 
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401  
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401  
    end
  end
end

RSpec.shared_examples "API unauthorized/POST" do 
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401  
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401  
    end
  end
end


RSpec.shared_examples "status 200" do 
  it 'returns 200 status' do 
    expect(response).to be_success
  end
end

RSpec.shared_examples "status 201" do 
  it 'returns 201 status' do 
    expect(response.status).to eq 201
  end
end

RSpec.shared_examples "status 422" do 
  it 'returns 422 status' do 
    expect(response.status).to eq 422
  end
end

RSpec.shared_examples "return list for(model, value, path)" do |model, value, path|
  it "return #{model} list" do
    if path.nil?
      expect(response.body).to have_json_size(value)
    else
      expect(response.body).to have_json_size(value).at_path(path)
    end
  end
end

RSpec.shared_examples "contains attributes" do |attributes|
  attributes.each do |attr|

    it "contains #{attr}" do
      expect(response.body).to be_json_eql(attributes_model.send(attr.to_sym).to_json).at_path(path + attr)
    end
  end
end

RSpec.shared_examples "does not contains attributes" do |attributes|
  attributes.each do |attr|

    it "contains #{attr}" do
      expect(response.body).to_not have_json_path(attr)
    end
  end
end

RSpec.shared_examples "model created" do |model_path|
  it 'return #{model_path} is present' do
    expect(response.body).to have_json_path(model_path)
  end
end

RSpec.shared_examples "model is not created" do |model_path|
  it 'return #{model_path} is not present' do
    expect(response.body).to_not have_json_path(model_path)
  end
end


RSpec.shared_examples "return errors" do
  it 'true' do
    expect(response.body).to have_json_path('errors')
  end
end    