class RemoveDistrictIdFromSectionStreets < ActiveRecord::Migration
  def up
    remove_column :section_streets, :district_id
  end

  def down
    add_column :section_streets, :district_id, :integer
    add_index :section_streets, :district_id
    add_foreign_key :section_streets, :districts
  end
end
