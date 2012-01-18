class CreateActiveDebtsAgreements < ActiveRecord::Migration
  def change
    create_table :active_debts_agreements, :id => false do |t|
      t.references :agreement, :active_debt
      t.boolean    :status
    end

    add_index :active_debts_agreements, :agreement_id
    add_index :active_debts_agreements, :active_debt_id
    add_index :active_debts_agreements, [:active_debt_id, :agreement_id, :status], :name => 'fk_active_debt_id_and_agreement_id_and_status'
    add_foreign_key :active_debts_agreements, :active_debts
    add_foreign_key :active_debts_agreements, :agreements
  end
end
