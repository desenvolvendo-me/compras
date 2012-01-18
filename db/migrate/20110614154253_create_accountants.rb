class CreateAccountants < ActiveRecord::Migration
  def change
    create_table :accountants do |t|
      t.integer :crc
      t.references :person

      t.timestamps
    end
    add_index :accountants, :person_id
    add_foreign_key :accountants, :people
  end
end
