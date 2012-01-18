class RenameMajorActivitiyInActivityEconomicRegistrations < ActiveRecord::Migration
  def up
    rename_column :activity_economic_registrations, :major_activitiy, :major_activity
  end

  def down
    rename_column :activity_economic_registrations, :major_activity, :major_activitiy
  end
end
