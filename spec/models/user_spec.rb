require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }

    it 'user is the author of the question' do
      question = create(:question, user: user)
      
      expect(user).to be_author_of(question)
    end

    it 'user is not the not author of the question' do
      question = create(:question, user: other_user)

      expect(user).to_not be_author_of(question)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    
    context "user already has authorization" do
      it "returns the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user has not authorization" do
      let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      it "does not create new user" do
        expect { User.find_for_oauth(auth) }.to_not change(User, :count)
      end

      it "create authorization for user" do
        expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
      end

      it "creates authorization with provider and uid" do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it "returns the user" do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user does not exists and email is present" do
      let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
      
      it "creates new user" do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it "returns new user" do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it "fils user email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it "creates authorization for users" do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end
      
      it "creats authorization with provider and uid" do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context "user does not exists and email is not present" do
      let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: nil }) }
      
      it "not change user count" do
        expect { User.find_for_oauth(auth) }.to_not change(User, :count)
      end
    end
  end

  describe ".create_from_oauth" do
    let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    email = "create_user@test.com"

    context "create user" do
      before { @user = User.create_from_oauth(email, auth) }

      it "check user email" do
        expect(@user.email).to eq email
      end

      it "password is present" do
        expect(@user.password).to be_present
      end

      context "check user authorization" do
        before { @authorization = @user.authorizations.first }

        it "provider" do
          expect(@authorization.provider).to eq 'facebook'
        end

        it "uid" do
          expect(@authorization.uid).to eq '123456'
        end
      end
    end
  end

  describe ".send_daily_digest" do
    let(:users) { create_list(:user, 2) }

    it "should send daily mailer to all users" do
      users.each {|user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest 
    end
  end
end
