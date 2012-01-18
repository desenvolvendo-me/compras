class AddPermissionToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :permission, :string
  end
end
