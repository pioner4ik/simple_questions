require 'rails_helper'

RSpec.describe Subscribtion, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  
  it { should have_db_index :user_id }
  it { should have_db_index :question_id }
end
