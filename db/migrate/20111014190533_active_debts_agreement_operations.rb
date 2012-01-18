class ActiveDebtsAgreementOperations < ActiveRecord::Migration
  def change
    create_table :active_debts_agreement_operations, :id => false do |t|
      t.references :agreement_operation, :active_debt
    end

    add_index :active_debts_agreement_operations, :agreement_operation_id, :name => 'fk_agreement_operation_id'
    add_index :active_debts_agreement_operations, :active_debt_id, :name => 'fk_active_debt_id'
    add_index :active_debts_agreement_operations, [:active_debt_id, :agreement_operation_id], :name => 'fk_agreement_operation_id_active_debt_id'
    add_foreign_key :active_debts_agreement_operations, :active_debts
    add_foreign_key :active_debts_agreement_operations, :agreement_operations
  end
end
