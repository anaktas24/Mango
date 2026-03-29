class CreateBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :description
      t.string :icon
      t.string :trigger, null: false


      t.timestamps
    end
  end
end
