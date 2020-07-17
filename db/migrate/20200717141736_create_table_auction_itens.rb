class CreateTableAuctionItens < ActiveRecord::Migration
  def change
    create_table :compras_auction_itens do |t|
      t.integer :purchase_solicitation_id
      t.integer :material_id
      t.integer :reference_unit_id
      t.string  :description
      t.text    :detailed_description
      t.decimal :estimated_value, precision: 16, scale: 2
      t.decimal :max_value, precision: 16, scale: 2
      t.string  :benefit_type
    end

    add_index :compras_auction_itens, :purchase_solicitation_id
    add_index :compras_auction_itens, :material_id
    add_index :compras_auction_itens, :reference_unit_id

    add_foreign_key :compras_auction_itens, :compras_purchase_solicitations,
                    column: :purchase_solicitation_id, name: :auction_itens_purchase_solicitation_id_fk

    add_foreign_key :compras_auction_itens, :compras_materials,
                    column: :material_id, name: :auction_itens_material_id_fk

    add_foreign_key :compras_auction_itens, :compras_reference_units,
                    column: :reference_unit_id, name: :auction_reference_unit_id_fk
  end
end
