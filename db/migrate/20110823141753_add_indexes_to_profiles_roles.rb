class AddIndexesToProfilesRoles < ActiveRecord::Migration
  def change
    add_index :profiles_roles, :role_id
    add_index :profiles_roles, :profile_id
  end
end
