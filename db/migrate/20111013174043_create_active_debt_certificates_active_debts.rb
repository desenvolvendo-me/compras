class CreateActiveDebtCertificatesActiveDebts < ActiveRecord::Migration
  def change
    create_table :active_debt_certificates_active_debts, :id => false do |t|
      t.integer :active_debt_certificate_id
      t.integer :active_debt_id
    end

    add_index :active_debt_certificates_active_debts, :active_debt_certificate_id, :name => :active_debt_certificate
    add_index :active_debt_certificates_active_debts, :active_debt_id, :name => :active_debt
    add_foreign_key :active_debt_certificates_active_debts, :active_debt_certificates, :name => :active_debt_certificates_fk
    add_foreign_key :active_debt_certificates_active_debts, :active_debts, :name => :active_debts_fk
  end
end
