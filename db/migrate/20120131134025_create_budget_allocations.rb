class CreateBudgetAllocations < ActiveRecord::Migration
  def change
    create_table :budget_allocations do |t|
      t.string :name

      t.timestamps
    end
  end
end
