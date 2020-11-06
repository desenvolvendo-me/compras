class CreateTableAuctionMessages < ActiveRecord::Migration
  def change
    create_table :compras_auction_messages do |t|
      t.integer :auction_conversation_id
      t.integer :sender_id
      t.text :message
      t.timestamps
    end

    add_index :compras_auction_messages, :auction_conversation_id, name: :index_on_auction_conversation_id
    add_index :compras_auction_messages, :sender_id, name: :index_on_sender_id

    add_foreign_key :compras_auction_messages, :compras_auction_conversations, column: :auction_conversation_id,
                    name: :c_auction_conversation_fk

    add_foreign_key :compras_auction_messages, :compras_users, column: :sender_id,
                    name: :c_sender_fk
  end
end
