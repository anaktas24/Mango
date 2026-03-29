class CreateUserQuests < ActiveRecord::Migration[8.1]
  def change
    create_table :user_quests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quest, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :position, null: false, default: 0
      t.string :share_token, index: { unique: true }

      t.timestamps
    end
  end
end
