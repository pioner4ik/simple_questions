require 'rails_helper'

RSpec.describe QuestionSubscribtionsJob, type: :job do
  let(:user)                  { create(:user) }
  let(:other_user)            { create(:user) }
  let(:question)              { create(:question, user: user) }
  let(:user_subscribe)        { create(:subscribe, question: question, user: user) }
  let(:other_user_subscribe)  { create(:subscribe, question: question, user: other_user) }
  let(:answer)                { create(:answer, question: question,user: other_user) }

  it "send notify to subscribed users" do
    question.subscribtions.each do |subscribe|
      expect(SubscribtionsMailer).to receive(:news).with(subscribe.user, answer).and_call_original
    end
    QuestionSubscribtionsJob.perform_now(answer)
  end
end
