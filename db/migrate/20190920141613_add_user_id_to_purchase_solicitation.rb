class AddUserIdToPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations, :user_id, :integer

    add_index :compras_purchase_solicitations, :user_id
    add_foreign_key :compras_purchase_solicitations, :compras_users, column: :user_id

  end
end
