class CreateDirectPurchaseBudgetAllocations < ActiveRecord::Migration
  def change
    create_table :direct_purchase_budget_allocations do |t|
      t.references :direct_purchase
      t.references :budget_allocation
      t.string :pledge_type

      t.timestamps
    end

    add_index :direct_purchase_budget_allocations, :direct_purchase_id, :name => 'dpba_direct_purchase_id'
    add_index :direct_purchase_budget_allocations, :budget_allocation_id, :name => 'dpba_budget_allocation_id'
    add_foreign_key :direct_purchase_budget_allocations, :direct_purchases, :name => 'dpba_direct_purchase_fk'
    add_foreign_key :direct_purchase_budget_allocations, :budget_allocations, :name => 'dpba_budget_allocation_fk'
  end
end
