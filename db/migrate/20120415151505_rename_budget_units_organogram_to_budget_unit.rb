class RenameBudgetUnitsOrganogramToBudgetUnit < ActiveRecord::Migration
  def change
    rename_column :budget_units, :organogram, :budget_unit
  end
end
