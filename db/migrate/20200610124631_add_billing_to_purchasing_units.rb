class AddBillingToPurchasingUnits < ActiveRecord::Migration
  def change
    add_column :compras_purchasing_units, :billing, :text
  end
end
