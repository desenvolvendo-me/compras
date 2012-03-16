class AddIndexAndForeignKeyToAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :condominium_id
    add_foreign_key :addresses, :condominiums
  end
end
