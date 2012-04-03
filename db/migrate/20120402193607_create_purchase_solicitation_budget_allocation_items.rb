class CreatePurchaseSolicitationBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table :purchase_solicitation_budget_allocation_items do |t|
      t.references :purchase_solicitation_budget_allocation
      t.references :material
      t.string :brand
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :purchase_solicitation_budget_allocation_items, :purchase_solicitation_budget_allocation_id, :name => 'psbai_purchase_solicitation_budget_allocation_id'
    add_index :purchase_solicitation_budget_allocation_items, :material_id, :name => 'psbai_material_id'
    add_foreign_key :purchase_solicitation_budget_allocation_items, :purchase_solicitation_budget_allocations, :name => 'psbai_purchase_solicitation_budget_allocation_fk'
    add_foreign_key :purchase_solicitation_budget_allocation_items, :materials, :name => 'psbai_material_fk'
  end
end
