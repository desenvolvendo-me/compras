class AddPurchaseSolicitationItemGroupToPurchaseSolicitationBudgetAllocationItem < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_budget_allocation_items, :purchase_solicitation_item_group_id, :integer

    add_index :compras_purchase_solicitation_budget_allocation_items,
              :purchase_solicitation_item_group_id, :name => :index_cpsbai_on_cpsig_id

    add_foreign_key :compras_purchase_solicitation_budget_allocation_items,
                    :compras_purchase_solicitation_item_groups,
                    :column => :purchase_solicitation_item_group_id,
                    :name => :cpsbai_psig_id_foreign_key
  end
end
