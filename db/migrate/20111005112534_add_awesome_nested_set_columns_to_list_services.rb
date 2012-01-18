class AddAwesomeNestedSetColumnsToListServices < ActiveRecord::Migration
  def change
    add_column :list_services, :lft, :integer
    add_column :list_services, :rgt, :integer
    add_column :list_services, :parent_id, :integer
    add_index  :list_services, :parent_id
    add_foreign_key :list_services, :list_services, :column => :parent_id
  end
end
