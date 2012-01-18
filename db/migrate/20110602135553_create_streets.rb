class CreateStreets < ActiveRecord::Migration
  def change
    create_table :streets do |t|
      t.string :name
      t.references :street_type
      t.string :zip_code
      t.string :tax_zone
      t.references :city

      t.timestamps
    end
    add_index :streets, :street_type_id
    add_index :streets, :city_id
    add_foreign_key :streets, :street_types
    add_foreign_key :streets, :cities
  end
end
