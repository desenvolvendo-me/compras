class CreateUserPurchasingUnits < ActiveRecord::Migration
  def change
    create_table :compras_user_purchasing_units do |t|
      t.references :user
      t.references :purchasing_unit

      t.timestamps
    end
    add_index :compras_user_purchasing_units, :user_id
    add_foreign_key :compras_user_purchasing_units,
                    :compras_users,:column => :user_id
    add_index :compras_user_purchasing_units, :purchasing_unit_id
    add_foreign_key :compras_user_purchasing_units,
                    :compras_purchasing_units,
                    :column => :purchasing_unit_id
  end
end