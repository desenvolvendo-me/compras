class CreateLicitationProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table :licitation_process_budget_allocation_items do |t|
      t.references :licitation_process_budget_allocation
      t.references :material
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :licitation_process_budget_allocation_items, :licitation_process_budget_allocation_id, :name => 'lpbai_allocation_id'
    add_index :licitation_process_budget_allocation_items, :material_id, :name => 'lpbai_material_id'
    add_foreign_key :licitation_process_budget_allocation_items, :licitation_process_budget_allocations, :name => 'lpbai_allocation_fk'
    add_foreign_key :licitation_process_budget_allocation_items, :materials, :name => 'lpbai_material_fk'
  end
end
