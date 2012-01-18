class AddZipCodeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :zip_code, :string
  end
end
