class RemoveStnOrdinanceIdFromExpenseEconomicClassifications < ActiveRecord::Migration
  def change
    remove_column :expense_economic_classifications, :stn_ordinance_id
  end
end
