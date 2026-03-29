class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  has_many :user_quests, dependent: :destroy
  has_many :quests, through: :user_quests
  has_many :user_steps, dependent: :destroy
  has_many :steps, through: :user_steps
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
end
