class CreateBudgetAllocationTypes < ActiveRecord::Migration
  def change
    create_table :budget_allocation_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
