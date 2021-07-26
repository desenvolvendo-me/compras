class RenameRevenueAccountingsToBudgetRevenues < ActiveRecord::Migration
  def change
    rename_table :compras_revenue_accountings, :compras_budget_revenues
  end
end
