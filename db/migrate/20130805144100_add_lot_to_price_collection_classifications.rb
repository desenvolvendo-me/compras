class AddLotToPriceCollectionClassifications < ActiveRecord::Migration
  def change
    add_column :compras_price_collection_classifications, :lot, :integer
  end
end
