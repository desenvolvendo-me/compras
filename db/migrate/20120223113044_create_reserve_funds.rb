class CreateReserveFunds < ActiveRecord::Migration
  def change
    create_table :reserve_funds do |t|
      t.integer :year
      t.integer :entity_id
      t.integer :budget_allocation_id
      t.decimal :value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :reserve_funds, :entity_id
    add_index :reserve_funds, :budget_allocation_id

    add_foreign_key :reserve_funds, :entities
    add_foreign_key :reserve_funds, :budget_allocations
  end
end
