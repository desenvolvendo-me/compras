class AddReleaseDateToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :release_date, :date
  end
end
