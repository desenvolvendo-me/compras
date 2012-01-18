class CreateActiveDebtsInstallmentTerms < ActiveRecord::Migration
  def change
    create_table :active_debts_installment_terms, :id => false do |t|
      t.integer :installment_term_id
      t.integer :active_debt_id
    end

    add_index :active_debts_installment_terms, :installment_term_id
    add_index :active_debts_installment_terms, :active_debt_id
    add_foreign_key :active_debts_installment_terms, :installment_terms
    add_foreign_key :active_debts_installment_terms, :active_debts
  end
end
