class AddActiveToEconomicRegistrations < ActiveRecord::Migration
  def change
    add_column :economic_registrations, :active, :boolean, :default => true
  end
end
