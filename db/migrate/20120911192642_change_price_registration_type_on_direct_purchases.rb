class ChangePriceRegistrationTypeOnDirectPurchases < ActiveRecord::Migration
  def up
    remove_column :compras_direct_purchases, :price_registration
    add_column :compras_direct_purchases, :price_registration_id, :integer

    add_index :compras_direct_purchases, :price_registration_id
    add_foreign_key :compras_direct_purchases, :compras_price_registrations, :column => :price_registration_id
  end

  def down
    remove_column :compras_direct_purchases, :price_registration_id
    add_column :compras_direct_purchases, :price_registration, :string
  end
end
