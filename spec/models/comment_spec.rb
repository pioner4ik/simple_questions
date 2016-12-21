require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should validate_length_of(:content).is_at_least(5) }
end
