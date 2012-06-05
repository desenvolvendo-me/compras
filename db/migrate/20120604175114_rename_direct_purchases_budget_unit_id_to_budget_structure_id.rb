class RenameDirectPurchasesBudgetUnitIdToBudgetStructureId < ActiveRecord::Migration
  def change
    rename_column :direct_purchases, :budget_unit_id, :budget_structure_id
  end
end
