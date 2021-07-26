class CreateComprasLicitationProcessesPriceCollections < ActiveRecord::Migration
  def up
    create_table :compras_price_collections_purchase_solicitations, id: false do |t|
      t.references :price_collection
      t.references :purchase_solicitation
    end

    add_foreign_key :compras_price_collections_purchase_solicitations, :compras_price_collections,
      column: :price_collection_id, name: :cpcps_price_collection_id_fk
    add_foreign_key :compras_price_collections_purchase_solicitations, :compras_purchase_solicitations,
      column: :purchase_solicitation_id, name: :cpcps_purchase_solicitation_id_fk

    add_index :compras_price_collections_purchase_solicitations, :price_collection_id,
      name: :index_cpcps_price_collection_id
    add_index :compras_price_collections_purchase_solicitations, :purchase_solicitation_id,
      name: :index_cpcps_purchase_solicitation_id
  end

  def down
    drop_table :compras_price_collections_purchase_solicitations
  end
end
