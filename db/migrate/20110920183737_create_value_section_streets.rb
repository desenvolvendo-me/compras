class CreateValueSectionStreets < ActiveRecord::Migration
  def change
    create_table :value_section_streets do |t|
      t.references :side_section_street
      t.references :section_street
       t.decimal :value_meter, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :value_section_streets, :side_section_street_id
    add_index :value_section_streets, :section_street_id
    add_foreign_key :value_section_streets, :side_section_streets
    add_foreign_key :value_section_streets, :section_streets
  end
end
