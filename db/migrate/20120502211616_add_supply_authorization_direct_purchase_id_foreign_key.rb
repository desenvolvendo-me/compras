class AddSupplyAuthorizationDirectPurchaseIdForeignKey < ActiveRecord::Migration
  def change
    add_foreign_key :supply_authorizations, :direct_purchases
  end
end
