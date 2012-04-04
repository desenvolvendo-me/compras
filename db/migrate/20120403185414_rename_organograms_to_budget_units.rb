class RenameOrganogramsToBudgetUnits < ActiveRecord::Migration
  def change
    rename_table :organograms, :budget_units
  end
end
