class RenameCollectionNumberToCodeFromComprasPriceCollections < ActiveRecord::Migration
  def change
    rename_column :compras_price_collections, :collection_number, :code
  end
end
