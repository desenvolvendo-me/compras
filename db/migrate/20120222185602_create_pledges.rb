class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.references :entity
      t.integer :year
      t.references :management_unit
      t.date :emission_date
      t.references :commitment_type
      t.references :budget_allocation
      t.decimal :value, :precision => 10, :scale => 2
      t.references :pledge_category

      t.timestamps
    end
    add_index :pledges, :entity_id
    add_index :pledges, :management_unit_id
    add_index :pledges, :commitment_type_id
    add_index :pledges, :budget_allocation_id
    add_index :pledges, :pledge_category_id

    add_foreign_key :pledges, :entities
    add_foreign_key :pledges, :management_units
    add_foreign_key :pledges, :commitment_types
    add_foreign_key :pledges, :budget_allocations
    add_foreign_key :pledges, :pledge_categories
  end
end
