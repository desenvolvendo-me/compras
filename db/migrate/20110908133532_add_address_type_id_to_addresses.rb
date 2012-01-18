class AddAddressTypeIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address_type_id, :integer
    add_index :addresses, :address_type_id
    add_foreign_key :addresses, :address_types
  end
end
