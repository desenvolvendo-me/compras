class RenameServiceTypesGoalToServiceTypesServiceGoal < ActiveRecord::Migration
  def change
    rename_column :service_types, :goal, :service_goal
  end
end
