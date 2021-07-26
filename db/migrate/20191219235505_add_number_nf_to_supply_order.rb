class AddNumberNfToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :number_nf, :string
  end
end