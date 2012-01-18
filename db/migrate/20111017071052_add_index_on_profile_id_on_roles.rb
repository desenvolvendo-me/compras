class AddIndexOnProfileIdOnRoles < ActiveRecord::Migration
  def change
    add_index :roles, :profile_id
  end
end
