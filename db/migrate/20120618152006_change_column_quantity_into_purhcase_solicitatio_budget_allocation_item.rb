class ChangeColumnQuantityIntoPurhcaseSolicitatioBudgetAllocationItem < ActiveRecord::Migration
  def change
    change_column :compras_purchase_solicitation_budget_allocation_items, :quantity, :decimal, :precision => 10, :scale => 2
  end
end
