 class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte]
         
  has_many :questions,      dependent: :destroy
  has_many :answers,        dependent: :destroy
  has_many :votes,          dependent: :destroy
  has_many :comments,       dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscribtions,  dependent: :destroy


  def author_of?(object)
    object.user_id == self.id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    elsif email.present?
      user = User.create_from_oauth(email, auth)
    end

    user
  end

  def self.create_from_oauth(email, auth)
    password = Devise.friendly_token[0, 20]
    user = User.create(email: email, password: password, password_confirmation: password)
    user.authorizations.create(provider: auth['provider'], uid: auth['uid'])
    user
  end
end
