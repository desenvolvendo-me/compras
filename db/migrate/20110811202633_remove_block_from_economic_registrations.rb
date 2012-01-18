class RemoveBlockFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_column :economic_registrations, :block
  end

  def down
    add_column :economic_registrations, :block, :string
  end
end
