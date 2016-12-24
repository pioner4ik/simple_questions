require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

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
    let!(:user)   { create(:user) }
    let(:auth_f)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:auth_v)  { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
    
    context "user already has authorization" do
      it "returns the user as facebook" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth_f)).to eq user
      end

      it "returns the user as vkontakte" do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth_v)).to eq user
      end
    end

    context "user has not authorization" do
      context "user already exists as facebook" do
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

      context "user already exists as vkontakte" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }
        #тест проходит, но тут не уверен, потому что хеш вк не должен отдавать параметр info
        #в логах при аутентификации уже зареганого полльзователя отдаеться только provider  и uid
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
    end

    context "user does not exists as facebook" do
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

    context "user does not exists as vkontakte" do
      let(:auth)  { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: nil }) }
      
      it "creates new user" do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it "returns new user" do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it "fils user email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq "user#{user.id}@test.com"
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
  end
end
