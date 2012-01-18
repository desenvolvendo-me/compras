class AddCorrespondenceAddressTypeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :correspondence_address_type, :string
  end
end
