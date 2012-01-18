class RemoveStreetIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :street_id
    remove_foreign_key :economic_registrations, :streets
    remove_column :economic_registrations, :street_id
  end

  def down
    add_column :economic_registrations, :street_id, :integer
    add_foreign_key :economic_registrations, :streets
    add_index :economic_registrations, :street_id
  end
end
