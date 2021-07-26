class AddPurchasedQuantityToPriceRegistrationItem < ActiveRecord::Migration
  def change
    add_column :compras_price_registration_items, :purchased_quantity, :integer, :default => 0
  end
end
