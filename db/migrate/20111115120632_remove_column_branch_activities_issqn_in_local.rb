class RemoveColumnBranchActivitiesIssqnInLocal < ActiveRecord::Migration
  def change
    remove_column :branch_activities, :issqn_in_local
  end
end
