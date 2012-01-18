class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.references :economic_registration
      t.references :person
      t.decimal :percentage, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :partners, :economic_registration_id
    add_index :partners, :person_id
    add_foreign_key :partners, :economic_registrations
    add_foreign_key :partners, :people
  end
end
