require "features_helper"
=begin
feature "" do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  let(:question)    { create(:question, user: user) }

  let(:model_name)  { question }

  it_behaves_like "votable"
=end

