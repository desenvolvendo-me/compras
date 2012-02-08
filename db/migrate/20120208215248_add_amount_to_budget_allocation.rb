class AddAmountToBudgetAllocation < ActiveRecord::Migration
  def change
    add_column :budget_allocations, :amount, :decimal, :precision => 10, :scale => 2
  end
end
