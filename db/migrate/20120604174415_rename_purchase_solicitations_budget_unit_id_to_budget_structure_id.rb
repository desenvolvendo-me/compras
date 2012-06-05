class RenamePurchaseSolicitationsBudgetUnitIdToBudgetStructureId < ActiveRecord::Migration
  def change
    rename_column :purchase_solicitations, :budget_unit_id, :budget_structure_id
  end
end
