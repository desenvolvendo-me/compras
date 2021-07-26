class RemoveMaterialIdFromPriceCollectionItems < ActiveRecord::Migration
  def up
    remove_column :compras_price_collection_items,
                  :material_id
  end

  def down
    add_column :compras_price_collection_items,
               :material_id, :integer
    add_index :compras_price_collection_items, :material_id
    add_foreign_key :compras_price_collection_items,
                    :compras_materials,
                    column: :material_id
  end
end
