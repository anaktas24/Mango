class QuestPrerequisite < ApplicationRecord
  belongs_to :quest
  belongs_to :prerequisite, class_name: "Quest"
end
