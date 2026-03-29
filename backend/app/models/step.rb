class Step < ApplicationRecord
  belongs_to :quest

  validates :title, presence: true
  validates :description, presence: true

  belongs_to :quest
  has_many :user_steps, dependent: :destroy
  has_many :users, through: :user_steps
end
