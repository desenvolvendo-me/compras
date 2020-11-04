class CreateTableAuctionChatMessages < ActiveRecord::Migration
  def change
    create_table :compras_auction_chat_messages do |t|
      t.integer :auction_chat_id
      t.integer :sender_id
      t.text :message
      t.timestamps
    end

    add_index :compras_auction_chat_messages, :auction_chat_id, name: :index_on_auction_chat_id
    add_index :compras_auction_chat_messages, :sender_id, name: :index_on_sender_id

    add_foreign_key :compras_auction_chat_messages, :compras_auction_chats, column: :auction_chat_id,
                    name: :c_auction_chat_fk

    add_foreign_key :compras_auction_chat_messages, :compras_users, column: :sender_id,
                    name: :c_sender_fk
  end
end
