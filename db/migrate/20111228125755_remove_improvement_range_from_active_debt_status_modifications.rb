class RemoveImprovementRangeFromActiveDebtStatusModifications < ActiveRecord::Migration
  def change
    remove_column :active_debt_status_modifications, :improvement_range
  end
end
