class RemoveActiveDebtCertificates < ActiveRecord::Migration
  def change
    remove_foreign_key :active_debt_certificates, :people
    remove_index :active_debt_certificates, :person_id
    drop_table :active_debt_certificates
  end
end
