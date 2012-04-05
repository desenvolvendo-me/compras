class RemoveExpenseElementeFromTablePurchaseSolicitation < ActiveRecord::Migration
  def change
    remove_column :purchase_solicitations, :expense_element_id
  end
end
