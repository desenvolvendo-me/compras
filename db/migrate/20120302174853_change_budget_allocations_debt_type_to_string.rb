class ChangeBudgetAllocationsDebtTypeToString < ActiveRecord::Migration
  def change
    change_column :budget_allocations, :debt_type, :string

    BudgetAllocation.where(:debt_type => '0').update_all(:debt_type => 'nothing')
    BudgetAllocation.where(:debt_type => '1').update_all(:debt_type => 'contract')
    BudgetAllocation.where(:debt_type => '2').update_all(:debt_type => 'secutities')
  end
end
