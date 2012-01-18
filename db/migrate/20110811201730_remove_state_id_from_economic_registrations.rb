class RemoveStateIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :state_id
    remove_foreign_key :economic_registrations, :states
    remove_column :economic_registrations, :state_id
  end

  def down
    add_column :economic_registrations, :state_id, :integer
    add_index :economic_registrations, :state_id
    add_foreign_key :economic_registrations, :states
  end
end
