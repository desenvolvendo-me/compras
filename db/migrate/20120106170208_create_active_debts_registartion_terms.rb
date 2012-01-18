class CreateActiveDebtsRegistartionTerms < ActiveRecord::Migration
  def change
    create_table :active_debts_registration_terms, :id => false do |t|
      t.integer :registration_term_id
      t.integer :active_debt_id
    end

    add_index :active_debts_registration_terms, :registration_term_id
    add_index :active_debts_registration_terms, :active_debt_id
    add_foreign_key :active_debts_registration_terms, :registration_terms
    add_foreign_key :active_debts_registration_terms, :active_debts
  end
end
