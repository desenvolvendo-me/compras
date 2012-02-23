class CreateCreditors < ActiveRecord::Migration
  def change
    create_table :creditors do |t|
      t.string :name
      t.string :status
      t.integer :entity_id

      t.timestamps
    end

    add_index :creditors, :entity_id

    add_foreign_key :creditors, :entities
  end
end
