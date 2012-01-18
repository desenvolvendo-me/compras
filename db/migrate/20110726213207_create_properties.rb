class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :number
      t.string :complement
      t.string :cep
      t.string :apartment
      t.string :apartment_block
      t.references :owner
      t.references :co_owner
      t.references :charging_type
      t.references :neighborhood
      t.references :district
      t.references :land_subdivision
      t.references :section_street
      t.decimal :measure_front, :decimal, :precision => 5, :scale => 2
      t.references :side_section_street
      t.date :construction_date
      t.string :registration
      t.boolean :rural
      t.boolean :active
      t.references :address_ticket
      t.string :image_blueprint
      t.text :observations

      t.timestamps
    end
    add_index :properties, :owner_id
    add_index :properties, :co_owner_id
    add_index :properties, :charging_type_id
    add_index :properties, :neighborhood_id
    add_index :properties, :district_id
    add_index :properties, :land_subdivision_id
    add_index :properties, :section_street_id
    add_index :properties, :side_section_street_id
    add_index :properties, :address_ticket_id
  end
end
