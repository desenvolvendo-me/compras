class RemoveLandSubdivisionIdFromProperties < ActiveRecord::Migration
  def up
    remove_foreign_key :properties, :land_subdivisions
    remove_index :properties, :land_subdivision_id
    remove_column :properties, :land_subdivision_id
  end

  def down
    add_column :properties, :land_subdivision_id, :integer
    add_foreign_key :properties, :land_subdivisions
    add_index :properties, :land_subdivision_id
  end
end
