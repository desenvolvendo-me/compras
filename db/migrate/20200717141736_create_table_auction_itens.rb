class CreateTableAuctionItens < ActiveRecord::Migration
  def change
    create_table :compras_auction_items do |t|
      t.integer :auction_id
      t.integer :material_id
      t.integer :reference_unit_id
      t.integer :lot
      t.decimal :estimated_value, precision: 16, scale: 2
      t.decimal :max_value, precision: 16, scale: 2
      t.string  :benefit_type
    end

    add_index :compras_auction_items, :auction_id
    add_index :compras_auction_items, :material_id
    add_index :compras_auction_items, :reference_unit_id

    add_foreign_key :compras_auction_items, :compras_auctions,
                    column: :auction_id, name: :auction_items_auction_id_fk

    add_foreign_key :compras_auction_items, :unico_materials,
                    column: :material_id, name: :auction_items_material_id_fk

    add_foreign_key :compras_auction_items, :compras_reference_units,
                    column: :reference_unit_id, name: :auction_reference_unit_id_fk
  end
end
