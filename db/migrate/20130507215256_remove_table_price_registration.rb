class RemoveTablePriceRegistration < ActiveRecord::Migration
  def change
    drop_table :compras_price_registration_budget_structures, :compras_price_registration_items
               :compras_price_registrations
  end
end
