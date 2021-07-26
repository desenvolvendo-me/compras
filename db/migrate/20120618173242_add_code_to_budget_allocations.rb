class AddCodeToBudgetAllocations < ActiveRecord::Migration
  def change
    add_column :compras_budget_allocations, :code, :integer
  end
end
