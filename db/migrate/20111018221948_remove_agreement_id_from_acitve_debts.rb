class RemoveAgreementIdFromAcitveDebts < ActiveRecord::Migration
  def change
    remove_column :active_debts, :agreement_id
  end
end
