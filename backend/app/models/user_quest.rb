class UserQuest < ApplicationRecord
  belongs_to :user
  belongs_to :quest

  enum :status, { not_started: 0, in_progress: 1, completed: 2 }

  validates :status, presence: true
end
