class RemoveStatusFromBudgetStructureResponsibles < ActiveRecord::Migration
  def change
    remove_column :compras_budget_structure_responsibles, :status
  end
end
