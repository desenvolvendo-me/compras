class RenameOrganogramResponsiblesToBudgetUnitResponsibles < ActiveRecord::Migration
  def change
    rename_table :organogram_responsibles, :budget_unit_responsibles
  end
end
