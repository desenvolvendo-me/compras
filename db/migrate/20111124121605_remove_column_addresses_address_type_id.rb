class RemoveColumnAddressesAddressTypeId < ActiveRecord::Migration
  def change
    remove_column :addresses, :address_type_id
  end
end
