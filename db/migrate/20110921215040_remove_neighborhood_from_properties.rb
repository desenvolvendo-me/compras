class RemoveNeighborhoodFromProperties < ActiveRecord::Migration
  def up
    remove_index :properties, :neighborhood_id
    remove_column :properties, :neighborhood_id
  end

  def down
    add_column :properties, :neighborhood_id, :integer
    add_foreign_key :properties, :neighborhoods
    add_index :properties, :neighborhood_id
  end
end
