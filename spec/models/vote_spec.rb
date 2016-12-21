require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should validate_numericality_of(:value).is_less_than_or_equal_to(1) }
  it { should validate_numericality_of(:value).is_greater_than_or_equal_to(-1) }
  it { should_not validate_numericality_of(:value).is_equal_to(0) }
end
