class CreateAdministrativeProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table :administrative_process_budget_allocation_items do |t|
      t.references :administrative_process_budget_allocation
      t.references :material
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :administrative_process_budget_allocation_items, :administrative_process_budget_allocation_id, :name => 'apbai_administrative_process_budget_allocation_id'
    add_index :administrative_process_budget_allocation_items, :material_id, :name => 'apbai_material_id'

    add_foreign_key :administrative_process_budget_allocation_items, :administrative_process_budget_allocations, :name => 'apbai_administrative_process_budget_allocation_fk'
    add_foreign_key :administrative_process_budget_allocation_items, :materials, :name => 'apbai_material_fk'
  end
end
