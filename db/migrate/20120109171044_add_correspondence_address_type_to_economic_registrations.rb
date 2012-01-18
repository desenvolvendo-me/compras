class AddCorrespondenceAddressTypeToEconomicRegistrations < ActiveRecord::Migration
  def change
    add_column :economic_registrations, :correspondence_address_type, :string
  end
end
