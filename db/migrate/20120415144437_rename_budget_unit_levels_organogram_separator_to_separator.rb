class RenameBudgetUnitLevelsOrganogramSeparatorToSeparator < ActiveRecord::Migration
  def change
    rename_column :budget_unit_levels, :organogram_separator, :separator
  end
end
