class AddProfileIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :profile_id, :integer
    add_foreign_key :roles, :profiles
  end
end
