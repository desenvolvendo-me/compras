class CreateStreetServices < ActiveRecord::Migration
  def change
    create_table :street_services do |t|
      t.string :year
      t.integer :sequency
      t.references :street
      t.references :section_street
      t.string :code
      t.references :field_type

      t.timestamps
    end
    add_index :street_services, :street_id
    add_index :street_services, :section_street_id
    add_index :street_services, :field_type_id
    add_foreign_key :street_services, :streets
    add_foreign_key :street_services, :section_streets
    add_foreign_key :street_services, :field_types
  end
end
