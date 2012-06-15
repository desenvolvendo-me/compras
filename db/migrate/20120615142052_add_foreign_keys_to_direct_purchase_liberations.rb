class AddForeignKeysToDirectPurchaseLiberations < ActiveRecord::Migration
  def change
    add_foreign_key :compras_direct_purchase_liberations, :compras_direct_purchases, :column => :direct_purchase_id
    add_foreign_key :compras_direct_purchase_liberations, :compras_employees, :column => :employee_id
  end
end
