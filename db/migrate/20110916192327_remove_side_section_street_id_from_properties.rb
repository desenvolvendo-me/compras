class RemoveSideSectionStreetIdFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :side_section_street_id
  end

  def down
    add_column :properties, :side_section_street_id, :integer
    add_index :properties, :side_section_street_id
    add_foreign_key :properties, :side_section_streets
  end
end
