class AddLoginTokenToUser < ActiveRecord::Migration
  def change
    add_column :compras_users, :login_token, :string
  end
end
