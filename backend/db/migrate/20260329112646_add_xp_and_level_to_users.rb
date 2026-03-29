class AddXpAndLevelToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :xp, :integer, null: false, default: 0
    add_column :users, :level, :integer, null: false, default: 0
  end
end
