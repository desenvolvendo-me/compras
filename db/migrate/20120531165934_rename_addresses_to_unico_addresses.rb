class RenameAddressesToUnicoAddresses < ActiveRecord::Migration
  def change
    rename_table :addresses, :unico_addresses
  end
end
