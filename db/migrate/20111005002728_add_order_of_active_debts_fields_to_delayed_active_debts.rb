class AddOrderOfActiveDebtsFieldsToDelayedActiveDebts < ActiveRecord::Migration
  def change
    add_column :delayed_active_debts, :order_of_active_debts_fields, :string
  end
end
