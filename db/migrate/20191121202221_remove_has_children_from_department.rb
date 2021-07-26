class RemoveHasChildrenFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,:has_children
  end
end
