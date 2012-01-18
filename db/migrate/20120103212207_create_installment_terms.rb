class CreateInstallmentTerms < ActiveRecord::Migration
  def change
    create_table :installment_terms do |t|
      t.integer :year
      t.integer :person_id
      t.integer :registrable_id
      t.string  :registrable_stype

      t.timestamps
    end

    add_index :installment_terms, :person_id
    add_foreign_key :installment_terms, :people
  end
end
