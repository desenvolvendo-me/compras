class CreateDirectPurchaseBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table :direct_purchase_budget_allocation_items do |t|
      t.references :direct_purchase_budget_allocation
      t.references :material
      t.string :brand
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :direct_purchase_budget_allocation_items, :direct_purchase_budget_allocation_id, :name => 'dpbai_budget_allocation_id'
    add_index :direct_purchase_budget_allocation_items, :material_id, :name => 'dpbai_material_id'
    add_foreign_key :direct_purchase_budget_allocation_items, :direct_purchase_budget_allocations, :name => 'dpbai_budget_allocation_fk'
    add_foreign_key :direct_purchase_budget_allocation_items, :materials, :name => 'dpbai_material_fk'
  end
end
