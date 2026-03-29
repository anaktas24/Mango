class Quest < ApplicationRecord
  enum :difficulty, { easy: 0, medium: 1, hard: 2 }

  validates :title, presence: true
  validates :description, presence: true
  validates :difficulty, presence: true

  has_many :quest_prerequisites, foreign_key: :quest_id, dependent: :destroy
  has_many :prerequisites, through: :quest_prerequisites, source: :prerequisite
  has_many :steps, dependent: :destroy
  has_many :user_quests, dependent: :destroy
  has_many :users, through: :user_quests
end
