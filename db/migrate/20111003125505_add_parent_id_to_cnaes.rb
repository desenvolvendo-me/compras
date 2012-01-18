class AddParentIdToCnaes < ActiveRecord::Migration
  def change
    add_column :cnaes, :parent_id, :integer
    add_index :cnaes, :parent_id
    add_foreign_key :cnaes, :cnaes, :column => 'parent_id'
  end
end
