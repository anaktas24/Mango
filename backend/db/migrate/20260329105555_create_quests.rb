class CreateQuests < ActiveRecord::Migration[8.1]
  def change
    create_table :quests do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :tips
      t.string :external_url
      t.string :estimated_duration
      t.integer :xp_reward, null: false, default: 0
      t.integer :priority, null: false, default: 0
      t.string :canton
      t.integer :difficulty, null: false, default: 0

      t.timestamps
    end
  end
end
