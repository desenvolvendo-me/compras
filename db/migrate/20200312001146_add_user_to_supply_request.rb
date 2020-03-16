class AddUserToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :user_id, :integer
    add_index :compras_supply_requests, :user_id
    add_foreign_key :compras_supply_requests, :compras_users, column: :user_id
  end
end