require 'rails_helper'

RSpec.describe Search, type: :model do

  describe '.detect_with_query' do
    let!(:q1) { create(:question, title: 'good') }
    let!(:q2) { create(:question, title: 'neutral') }

    let!(:a1) { create(:answer, body: 'good') }
    let!(:a2) { create(:answer, body: 'neutral') }

    let!(:c1) { create(:comment, content: 'good', commentable: q1) }
    let!(:c2) { create(:comment, content: 'neutral', commentable: q2) }

    let!(:u1) { create(:user, email: 'good@mail.ru') }
    let!(:u2) { create(:user, email: 'neutral@mail.ru') }

    before { index }

    context 'when detected', :sphinx do

      it 'returns requested objects' do
        expect(Search.detect_with_query('all', 'good')).to match_array [q1, a1, c1, u1]
      end

      it 'returns requested objects with strip query' do
        expect(Search.detect_with_query('all', 'neu')).to match_array [q2, a2, c2, u2]
      end

      it 'returns requested questions' do
        expect(Search.detect_with_query('question', 'good')).to match_array [q1]
      end

      it 'returns requested answers' do
        expect(Search.detect_with_query('answer', 'good')).to match_array [a1]
      end

      it 'returns requested comments' do
        expect(Search.detect_with_query('comment', 'good')).to match_array [c1]
      end

      it 'returns requested users' do
        expect(Search.detect_with_query('user', 'good')).to match_array [u1]
      end
    end

    context 'when not found' do
      it 'returns empty array when category not present' do
        expect(Search.detect_with_query('all', nil)).to match_array []
      end

      it 'returns empty array when query not present' do
        expect(Search.detect_with_query(nil, 'find')).to match_array []
      end
    end
  end
end
