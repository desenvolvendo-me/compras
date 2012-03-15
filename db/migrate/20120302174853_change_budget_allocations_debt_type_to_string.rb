class ChangeBudgetAllocationsDebtTypeToString < ActiveRecord::Migration
  def up
    change_column :budget_allocations, :debt_type, :string

    BudgetAllocation.where(:debt_type => '0').update_all(:debt_type => 'nothing')
    BudgetAllocation.where(:debt_type => '1').update_all(:debt_type => 'contract')
    BudgetAllocation.where(:debt_type => '2').update_all(:debt_type => 'secutities')
  end

  def down
    BudgetAllocation.where(:debt_type => 'nothing').update_all(:debt_type => '0')
    BudgetAllocation.where(:debt_type => 'contract').update_all(:debt_type => '1')
    BudgetAllocation.where(:debt_type => 'secutities').update_all(:debt_type => '2')

    change_column :budget_allocations, :debt_type, :integer
  end
end
