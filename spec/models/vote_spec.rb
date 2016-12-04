require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :vote_type }
end
