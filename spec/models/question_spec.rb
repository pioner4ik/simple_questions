require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_db_index :user_id }

  it { should accept_nested_attributes_for :attachments }
end
