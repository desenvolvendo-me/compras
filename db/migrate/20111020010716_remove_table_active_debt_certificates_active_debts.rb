class RemoveTableActiveDebtCertificatesActiveDebts < ActiveRecord::Migration
  def change
    remove_index :active_debt_certificates_active_debts, :name => :active_debt_certificate
    remove_index :active_debt_certificates_active_debts, :name => :active_debt
    remove_foreign_key :active_debt_certificates_active_debts, :name => :active_debt_certificates_fk
    remove_foreign_key :active_debt_certificates_active_debts, :name => :active_debts_fk
    drop_table :active_debt_certificates_active_debts
  end
end
