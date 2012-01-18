class RemoveDueDateFromActiveDebtStatusModifications < ActiveRecord::Migration
  def change
    remove_column :active_debt_status_modifications, :due_date
  end
end
