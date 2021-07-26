class CreateTableAuctionConversations < ActiveRecord::Migration
  def change
    create_table :compras_auction_conversations do |t|
      t.integer :auction_id
      t.boolean :is_enabled
    end

    add_index :compras_auction_conversations, :auction_id, name: :index_c_auct_conver_on_auction_id

  end
end
