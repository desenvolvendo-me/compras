class CreditorRepresentatives < ActiveRecord::Migration
  def change
    create_table :creditor_representatives do | t |
      t.references :creditor
      t.integer :representative_person_id
    end

    add_index :creditor_representatives, :creditor_id
    add_index :creditor_representatives, :representative_person_id
    add_foreign_key :creditor_representatives, :creditors
    add_foreign_key :creditor_representatives, :people, :column => 'representative_person_id'
  end
end
