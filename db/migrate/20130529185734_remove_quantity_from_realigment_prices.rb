class RemoveQuantityFromRealigmentPrices < ActiveRecord::Migration
  def up
    remove_column :compras_realigment_prices, :quantity
  end

  def down
    add_column :compras_realigment_prices, :quantity, :integer
  end
end
