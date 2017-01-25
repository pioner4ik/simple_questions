require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "attachable"
  it_behaves_like "commentable"
  it_behaves_like "votable"

  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :body }
  it { should have_db_index :user_id}
  it { should have_db_index :question_id }
  
  describe " mark_answer_best " do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer_1) { create(:answer, question: question, user: user) }
    let!(:answer_2) { create(:answer, question: question, user: user) }

    it "mark best first answer" do
      answer_1.update(best: false)
      answer_2.update(best: true)

      answer_1.mark_answer_best

      answer_1.reload
      answer_2.reload

      expect(answer_1.best).to eq true
      expect(answer_2.best).to eq false
    end
  end
end
