class RenameColumnRequimentNumberInMovementEconomicRegistrations < ActiveRecord::Migration
  def up
    rename_column :movement_economic_registrations, :requiment_number, :requirement_number
  end

  def down
    rename_column :movement_economic_registrations, :requirement_number, :requiment_number
  end
end
