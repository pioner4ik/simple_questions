class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :vote_type, polymorphic: true

  #validates_uniqueness_of :user, scope: :vote_type
end
