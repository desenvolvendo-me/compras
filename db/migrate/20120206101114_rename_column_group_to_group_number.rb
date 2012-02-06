class RenameColumnGroupToGroupNumber < ActiveRecord::Migration
  def change
    rename_column :materials_groups, :group, :group_number
  end
end
