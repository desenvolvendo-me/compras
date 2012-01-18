class RemoveNeighborhoodIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :neighborhood_id
    remove_foreign_key :economic_registrations, :neighborhoods
    remove_column :economic_registrations, :neighborhood_id
  end

  def down
    add_column :economic_registrations, :neighborhood_id, :integer
    add_foreign_key :economic_registrations, :neighborhoods
    add_index :economic_registrations, :neighborhood_id
  end
end
