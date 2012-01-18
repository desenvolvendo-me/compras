class CreateActiveDebtCertificatesActiveDebtsAgain < ActiveRecord::Migration
  def change
    create_table :active_debt_certificates_active_debts, :id => false do |t|
      t.integer :active_debt_certificate_id
      t.integer :active_debt_id
    end

    add_index :active_debt_certificates_active_debts, :active_debt_certificate_id, :name => :adcad_active_debt_certificate_id
    add_index :active_debt_certificates_active_debts, :active_debt_id
    add_foreign_key :active_debt_certificates_active_debts, :active_debt_certificates, :name => :adcad_active_debt_certificate_fk
    add_foreign_key :active_debt_certificates_active_debts, :active_debts
  end
end
