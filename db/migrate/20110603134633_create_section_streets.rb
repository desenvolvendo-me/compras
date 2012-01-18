class CreateSectionStreets < ActiveRecord::Migration
  def change
    create_table :section_streets do |t|
      t.string :base_year
      t.references :district
      t.references :street
      t.references :neighborhood
      t.integer :section
      t.references :side_street
      t.decimal :value_meter, :decimal, :precision => 5, :scale => 2

      t.timestamps
    end
    add_index :section_streets, :district_id
    add_index :section_streets, :street_id
    add_index :section_streets, :neighborhood_id
    add_index :section_streets, :side_street_id
    add_foreign_key :section_streets, :districts
    add_foreign_key :section_streets, :streets
    add_foreign_key :section_streets, :neighborhoods
    add_foreign_key :section_streets, :side_streets
  end
end
