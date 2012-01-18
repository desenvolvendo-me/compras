class RemoveNeighborhoodIdFromSectionStreets < ActiveRecord::Migration
  def up
    remove_column :section_streets, :neighborhood_id
  end

  def down
    add_column :section_streets, :neighborhood_id, :integer
    add_index :section_streets, :neighborhood_id
    add_foreign_key :section_streets, :neighborhoods
  end
end
