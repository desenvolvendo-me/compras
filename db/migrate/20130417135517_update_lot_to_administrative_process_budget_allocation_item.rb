class UpdateLotToAdministrativeProcessBudgetAllocationItem < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE compras_administrative_process_budget_allocation_items
      SET lot = 1
      WHERE lot is null or lot <= 0
    SQL
  end
end
