class AddStatusToActiveDebtStatusModifications < ActiveRecord::Migration
  def change
    add_column :active_debt_status_modifications, :status, :string
  end
end
