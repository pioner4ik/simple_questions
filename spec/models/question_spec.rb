require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "attachable"
  it_behaves_like "commentable"
  it_behaves_like "votable"

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribtions).dependent(:destroy) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_db_index :user_id }
end
