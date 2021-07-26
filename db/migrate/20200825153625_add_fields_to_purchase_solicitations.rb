class AddFieldsToPurchaseSolicitations < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations, :delivery_location_field, :string
    add_column :compras_price_collections, :delivery_location_field, :string
  end
end
