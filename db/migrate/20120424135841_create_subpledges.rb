class CreateSubpledges < ActiveRecord::Migration
  def change
    create_table :subpledges do |t|
      t.references :entity
      t.integer :year
      t.references :pledge
      t.integer :number
      t.references :creditor
      t.date :date
      t.decimal :value
      t.string :process_number
      t.text :description

      t.timestamps
    end

    add_index :subpledges, :entity_id
    add_index :subpledges, :pledge_id
    add_index :subpledges, :creditor_id

    add_foreign_key :subpledges, :entities
    add_foreign_key :subpledges, :pledges
    add_foreign_key :subpledges, :creditors
  end
end
