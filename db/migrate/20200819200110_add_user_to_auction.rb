class AddUserToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions,
               :user_id, :integer
    add_index :compras_auctions, :user_id
    add_foreign_key :compras_auctions, :compras_users,
                    :column => :user_id
  end
end
