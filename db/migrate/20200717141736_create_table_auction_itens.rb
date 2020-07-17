class CreateTableAuctionItens < ActiveRecord::Migration
  def change
    create_table :compras_auction_itens do |t|
      t.integer :purchase_solicitation_id
      t.integer :material_id
      t.string  :material_classification
      t.string  :description
      t.text    :detailed_description
      t.decimal :estimated_value, precision: 16, scale: 2
      t.decimal :max_value, precision: 16, scale: 2
      t.string  :benefit_type
      t.integer :quantity_item
    end
  end
end
