class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :vote_type, polymorphic: true
end
