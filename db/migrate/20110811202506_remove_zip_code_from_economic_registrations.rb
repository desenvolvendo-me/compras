class RemoveZipCodeFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_column :economic_registrations, :zip_code
  end

  def down
    add_column :economic_registrations, :zip_code, :string
  end
end
