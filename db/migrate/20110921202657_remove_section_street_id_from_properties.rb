class RemoveSectionStreetIdFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :section_street_id
  end

  def down
    add_column :properties, :section_street_id, :integer
    add_index :properties, :section_street_id
    add_foreign_key :properties, :section_streets
  end
end
