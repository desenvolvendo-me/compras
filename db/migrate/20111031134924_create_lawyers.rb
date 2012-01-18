class CreateLawyers < ActiveRecord::Migration
  def change
    create_table :lawyers do |t|
      t.references :person
      t.string :oab_registration
      t.string :oab_section

      t.timestamps
    end
    add_index :lawyers, :person_id
    add_foreign_key :lawyers, :people
  end
end
