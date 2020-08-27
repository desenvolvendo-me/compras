class RemoveTablePriceRegistration < ActiveRecord::Migration
  def change
    drop_table :compras_price_registration_budget_structures
    drop_table :compras_price_registration_items
  end
end
