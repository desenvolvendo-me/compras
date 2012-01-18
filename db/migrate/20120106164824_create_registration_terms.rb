class CreateRegistrationTerms < ActiveRecord::Migration
  def change
    create_table :registration_terms do |t|
      t.string :year
      t.integer :person_id
      t.integer :registrable_id
      t.string :registrable_type

      t.timestamps
    end

    add_index :registration_terms, :person_id
    add_foreign_key :registration_terms, :people
  end
end
