class CreatePrefectures < ActiveRecord::Migration
  def change
    create_table :prefectures do |t|
      t.string :name
      t.string :acronym
      t.string :cnpj
      t.references :city
      t.references :street
      t.references :neighborhood
      t.integer :number
      t.string :zip_code
      t.string :complement
      t.string :phone
      t.string :fax
      t.string :email
      t.string :mayor_name

      t.timestamps
    end
    add_index :prefectures, :city_id
    add_index :prefectures, :street_id
    add_index :prefectures, :neighborhood_id
    add_foreign_key :prefectures, :cities
    add_foreign_key :prefectures, :streets
    add_foreign_key :prefectures, :neighborhoods
  end
end
