class RemoveNumberFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_column :economic_registrations, :number
  end

  def down
    add_column :economic_registrations, :number, :integer
  end
end
