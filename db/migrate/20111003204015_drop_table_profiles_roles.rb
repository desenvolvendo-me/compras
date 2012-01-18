class DropTableProfilesRoles < ActiveRecord::Migration
  def change
    drop_table :profiles_roles
  end
end
