class RemoveCityIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :city_id
    remove_foreign_key :economic_registrations, :cities
    remove_column :economic_registrations, :city_id
  end

  def down
    add_column :economic_registrations, :city_id, :integer
    add_index :economic_registrations, :city_id
    add_foreign_key :economic_registrations, :cities
  end
end
