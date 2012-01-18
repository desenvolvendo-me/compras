class AddValueSectionStreetIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :value_section_street_id, :integer
    add_index :properties, :value_section_street_id
    add_foreign_key :properties, :value_section_streets
  end
end
