class CreatePersonIdentities < ActiveRecord::Migration
  def change
    create_table :person_identities do |t|
      t.references :person
      t.string :number
      t.string :issuer
      t.date :issue
      t.references :state

      t.timestamps
    end

    add_foreign_key :person_identities, :people
    add_foreign_key :person_identities, :states
  end
end
