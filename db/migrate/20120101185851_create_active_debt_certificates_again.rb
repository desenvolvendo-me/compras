class CreateActiveDebtCertificatesAgain < ActiveRecord::Migration
  def change
    create_table :active_debt_certificates do |t|
      t.string :year
      t.integer :person_id
      t.timestamps
    end

    add_index :active_debt_certificates, :person_id
    add_foreign_key :active_debt_certificates, :people
  end
end
