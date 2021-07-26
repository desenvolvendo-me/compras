class AddBudgetAllocationStringPledgeRequest < ActiveRecord::Migration
  def up
    add_column :compras_pledge_requests,
               :budget_allocation,:string
  end

  def down
    remove_column :compras_pledge_requests,:budget_allocation
  end
end
