require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  
  it { should validate_presence_of :body }
  it { should have_db_index :user_id}
  it { should have_db_index :question_id }
  
  it { should accept_nested_attributes_for :attachments }
  
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

=begin Подумал что этот тест тут в принципе не нужен,потому что тест выше 
      тестит связь в обе стороны.Оставил на всякий случай
    it "mark best second answer" do
      answer_1.update(best: true)
      answer_2.update(best: false)

      answer_2.mark_answer_best
      
      answer_1.reload
      answer_2.reload


      expect(answer_1.best).to eq false
      expect(answer_2.best).to eq true
    end
=end    
  end
end
