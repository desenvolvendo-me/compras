class RemoveMajorActivityFromActivityEconomicRegistrations < ActiveRecord::Migration
  def change
    remove_column :activity_economic_registrations, :major_activity
  end
end
