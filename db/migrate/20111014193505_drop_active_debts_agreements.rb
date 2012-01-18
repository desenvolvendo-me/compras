class DropActiveDebtsAgreements < ActiveRecord::Migration
  def change
    drop_table :active_debts_agreements
  end
end
