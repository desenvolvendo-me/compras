class CreateCapabilities < ActiveRecord::Migration
  def change
    create_table :capabilities do |t|
      t.integer :entity_id
      t.integer :year
      t.string :description
      t.text :goal
      t.string :kind

      t.timestamps
    end

    add_index :capabilities, :entity_id

    add_foreign_key :capabilities, :entities
  end
end
