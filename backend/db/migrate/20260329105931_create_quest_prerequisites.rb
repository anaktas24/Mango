class CreateQuestPrerequisites < ActiveRecord::Migration[8.1]
  def change
    create_table :quest_prerequisites do |t|
      t.references :quest, null: false, foreign_key: true
      t.references :prerequisite, null: false, foreign_key: { to_table: :quests }


      t.timestamps
    end
  end
end
