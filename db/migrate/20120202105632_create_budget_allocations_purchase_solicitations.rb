class CreateBudgetAllocationsPurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table :budget_allocations_purchase_solicitations, :id => false do |t|
      t.integer :budget_allocation_id
      t.integer :purchase_solicitation_id
    end
    add_index :budget_allocations_purchase_solicitations, :budget_allocation_id, :name => :baps_budget_allocation_id
    add_index :budget_allocations_purchase_solicitations, :purchase_solicitation_id, :name => :baps_purchase_solicitation_id
    add_foreign_key :budget_allocations_purchase_solicitations, :budget_allocations, :name => :baps_budget_allocation_id_fk
    add_foreign_key :budget_allocations_purchase_solicitations, :purchase_solicitations, :name => :baps_purchase_solicitation_id_fk
  end
end
