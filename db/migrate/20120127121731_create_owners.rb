class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.references :property
      t.references :person
      t.decimal :percentage

      t.timestamps
    end
    add_index :owners, :property_id
    add_index :owners, :person_id
  end
end
