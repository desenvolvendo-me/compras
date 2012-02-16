class ChangeBudgetAllocationsDescriptionToText < ActiveRecord::Migration
  def up
    change_column :budget_allocations, :description, :text
  end

  def down
    change_column :budget_allocations, :description, :string
  end
end
