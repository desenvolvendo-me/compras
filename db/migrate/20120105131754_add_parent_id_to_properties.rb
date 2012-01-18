class AddParentIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :parent_id, :integer
    add_index :properties, :parent_id
    add_foreign_key :properties, :properties, :column => :parent_id
  end
end
