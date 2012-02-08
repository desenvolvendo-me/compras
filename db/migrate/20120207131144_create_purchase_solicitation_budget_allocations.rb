class CreatePurchaseSolicitationBudgetAllocations < ActiveRecord::Migration
  def change
    create_table :purchase_solicitation_budget_allocations do |t|
      t.references :purchase_solicitation
      t.references :budget_allocation
      t.decimal :estimated_value, :precision => 10, :scale => 2
      t.decimal :expense_complement, :precision => 10, :scale => 2
      t.boolean :blocked

      t.timestamps
    end
    add_index :purchase_solicitation_budget_allocations, :purchase_solicitation_id, :name => 'psba_purchase_solicitation_id'
    add_index :purchase_solicitation_budget_allocations, :budget_allocation_id, :name => 'psba_budget_allocation_id'

    add_foreign_key :purchase_solicitation_budget_allocations, :purchase_solicitations, :name => 'psba_purchase_solicitation_fk'
    add_foreign_key :purchase_solicitation_budget_allocations, :budget_allocations, :name => 'psba_budget_allocation_fk'
  end
end
