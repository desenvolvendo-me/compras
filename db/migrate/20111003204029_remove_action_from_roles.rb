class RemoveActionFromRoles < ActiveRecord::Migration
  def change
    remove_column :roles, :action
  end
end
