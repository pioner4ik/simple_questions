class Question < ApplicationRecord
  include Attachable
  include Commentable
  include Votable
  
  after_create :create_subscribtion
  
  #default_scope -> { order("created_at DESC") }

  has_many :answers, dependent: :destroy
  has_many :subscribtions, dependent: :destroy

  belongs_to :user
  
  validates :title, :body, presence: true

  def subscribtion_for(user)
    @subscribtion ||= subscribtions.where(user: user).first
  end

  private
  
    def create_subscribtion
      subscribtions.create(user: user)
    end
end
