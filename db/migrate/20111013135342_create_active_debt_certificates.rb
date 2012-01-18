class CreateActiveDebtCertificates < ActiveRecord::Migration
  def change
    create_table :active_debt_certificates do |t|
      t.integer :year
      t.integer :person_id
      t.integer :registrable_id
      t.string  :registrable_stype

      t.timestamps
    end

    add_index :active_debt_certificates, :person_id
    add_foreign_key :active_debt_certificates, :people
  end
end
