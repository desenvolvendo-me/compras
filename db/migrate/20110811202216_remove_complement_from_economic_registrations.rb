class RemoveComplementFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_column :economic_registrations, :complement
  end

  def down
    add_column :economic_registrations, :complement, :text
  end
end
