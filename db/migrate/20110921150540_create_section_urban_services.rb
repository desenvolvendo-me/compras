class CreateSectionUrbanServices < ActiveRecord::Migration
  def change
    create_table :section_urban_services do |t|
      t.references :urban_service
      t.references :value_section_street
      t.references :reference_unit
      t.string :value

      t.timestamps
    end
    add_index :section_urban_services, :urban_service_id
    add_index :section_urban_services, :value_section_street_id
    add_index :section_urban_services, :reference_unit_id
    add_foreign_key :section_urban_services, :urban_services
    add_foreign_key :section_urban_services, :value_section_streets
    add_foreign_key :section_urban_services, :reference_units
  end
end
