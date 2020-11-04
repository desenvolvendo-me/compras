class CreateTableAuctionChats < ActiveRecord::Migration
  def change
    create_table :compras_auction_chats do |t|
      t.integer :auction_id
      t.boolean :is_enabled
    end

    add_index :compras_auction_chats, :auction_id, name: :index_c_auct_chat_on_auction_id

    add_foreign_key :compras_auction_chats, :compras_auctions, column: :auction_id,
                    name: :c_auct_chat_auction_fk
  end
end
