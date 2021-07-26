class AddExpenseToPurchaseForm < ActiveRecord::Migration
  def change
    add_column :compras_purchase_forms,
               :expense_id, :integer
    add_index :compras_purchase_forms, :expense_id
    add_foreign_key :compras_purchase_forms, :compras_expenses,
                    :column => :expense_id
  end
end
