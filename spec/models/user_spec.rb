require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
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
end
