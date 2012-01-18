class RemoveRoomFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_column :economic_registrations, :room
  end

  def down
    add_column :economic_registrations, :room, :string
  end
end
