class AddChatActivatedToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :chat_activated, :boolean, :default => false
  end
end
