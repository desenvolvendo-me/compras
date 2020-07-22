class CreateTableAuctionGroupItens < ActiveRecord::Migration
  def change
    create_table :compras_auction_group_items do |t|
      t.integer  :auction_id
      t.string   :purchase_type
      t.string   :group_form
      t.string   :group
      t.integer  :quantity
      t.string   :judment_form
      t.decimal  :total_value, precision: 16, scale: 2
      t.decimal  :max_value, precision: 16, scale: 2
      t.string   :benefit_type
    end

    add_index :compras_auction_group_items, :auction_id

    add_foreign_key :compras_auction_group_items, :compras_auctions,
                    column: :auction_id, name: :auction_group_items_auction_id_fk
  end
end
