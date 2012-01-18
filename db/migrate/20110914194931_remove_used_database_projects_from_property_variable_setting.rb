class RemoveUsedDatabaseProjectsFromPropertyVariableSetting < ActiveRecord::Migration
  def up
    remove_column :property_variable_settings, :used_database_projects
  end

  def down
    add_column :property_variable_settings, :used_database_projects, :boolean
  end
end
