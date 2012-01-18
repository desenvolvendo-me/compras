class RemoveSectionStreetIdFromUrbanServices < ActiveRecord::Migration
  def up
    remove_column :urban_services, :section_street_id
  end

  def down
    add_column :urban_services, :section_street_id, :integer
    add_index :urban_services, :section_street_id
    add_foreign_key :urban_services, :section_streets
  end
end
