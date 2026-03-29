class UserStep < ApplicationRecord
  belongs_to :user
  belongs_to :step

  validates :completed, inclusion: { in: [ true, false ] }
end
