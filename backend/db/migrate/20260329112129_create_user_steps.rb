class CreateUserSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :user_steps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :step, null: false, foreign_key: true
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
