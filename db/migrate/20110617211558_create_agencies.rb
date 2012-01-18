class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :number
      t.string :digit
      t.references :city
      t.references :bank
      t.string :phone
      t.string :fax
      t.string :email

      t.timestamps
    end
    add_index :agencies, :city_id
    add_index :agencies, :bank_id

    add_foreign_key :agencies, :cities
    add_foreign_key :agencies, :banks
  end
end
