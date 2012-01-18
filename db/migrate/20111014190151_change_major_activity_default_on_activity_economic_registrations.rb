class ChangeMajorActivityDefaultOnActivityEconomicRegistrations < ActiveRecord::Migration
  def up
    change_column_default :activity_economic_registrations, :major_activity, false
  end

  def down
    change_column_default :activity_economic_registrations, :major_activity, nil
  end
end
