require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should have_db_index :user_id}
  it { should have_db_index :question_id }

  describe " mark_answer_best " do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer_1) { create(:answer, question: question, user: user) }
    let(:answer_2) { create(:answer, question: question, user: user) }
    let(:answer_3) { create(:answer, question: question, user: user) }

    it "mark best first answer" do
      answer_1.mark_answer_best

      expect(answer_1.best).to eq true
      expect(answer_2.best).to eq false
      expect(answer_3.best).to eq false
    end

    it "mark best second answer" do
      answer_2.mark_answer_best

      expect(answer_1.best).to eq false
      expect(answer_2.best).to eq true
      expect(answer_3.best).to eq false
    end
  end
end
