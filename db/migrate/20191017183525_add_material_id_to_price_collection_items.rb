class AddMaterialIdToPriceCollectionItems < ActiveRecord::Migration
  def change
    add_column :compras_price_collection_items,
               :material_id, :integer
    add_index :compras_price_collection_items, :material_id
    # add_foreign_key :compras_price_collection_items,
    #                 :unico_materials,
    #                 column: :material_id
  end
end
