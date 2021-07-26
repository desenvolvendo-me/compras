class RemoveDirectPurchasesAndTablesUnused < ActiveRecord::Migration
  def change
    drop_table :compras_prefectures
    drop_table :compras_supply_authorizations
    drop_table :compras_direct_purchase_budget_allocation_items
    drop_table :compras_direct_purchase_budget_allocations
    drop_table :compras_direct_purchases
    drop_table :compras_price_registration_items
    drop_table :compras_price_registrations
  end
end
