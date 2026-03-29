class CreateSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :position, null: false, default: 0
      t.integer :xp_reward, null: false, default: 0
      t.references :quest, null: false, foreign_key: true


      t.timestamps
    end
  end
end
