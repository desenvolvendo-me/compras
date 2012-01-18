class ChangeSideStreetIdToSideSectionStreetIdOnSectionStreets < ActiveRecord::Migration
  def up
    remove_index :section_streets, :side_street_id
    remove_foreign_key :section_streets, :side_streets
    rename_column :section_streets, :side_street_id, :side_section_street_id
    add_foreign_key :section_streets, :side_section_streets
    add_index :section_streets, :side_section_street_id
  end
  
  def down
    remove_index :section_streets, :side_section_street_id
    remove_foreign_key :section_streets, :side_section_streets
    rename_column :section_streets, :side_section_street_id, :side_street_id
    add_foreign_key :section_streets, :side_streets
    add_index :section_streets, :side_street_id
  end
end