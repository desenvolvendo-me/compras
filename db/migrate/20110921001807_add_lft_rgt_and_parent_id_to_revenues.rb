class AddLftRgtAndParentIdToRevenues < ActiveRecord::Migration
  def change
    add_column :revenues, :lft, :integer
    add_column :revenues, :rgt, :integer

    add_column :revenues, :parent_id, :integer
    add_index :revenues, :parent_id
    add_foreign_key :revenues, :revenues, :column => :parent_id
  end
end
