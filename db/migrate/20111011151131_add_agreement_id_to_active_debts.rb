class AddAgreementIdToActiveDebts < ActiveRecord::Migration
  def change
    add_column :active_debts, :agreement_id, :integer
    add_index :active_debts, :agreement_id
    add_foreign_key :active_debts, :agreements
  end
end
