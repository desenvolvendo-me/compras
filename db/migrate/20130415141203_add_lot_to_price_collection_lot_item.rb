class AddLotToPriceCollectionLotItem < ActiveRecord::Migration
  def change
    add_column :compras_price_collection_lot_items, :lot, :integer
  end
end
