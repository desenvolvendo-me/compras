class RemoveActiveDebtsComplaints < ActiveRecord::Migration
  def change
    remove_foreign_key :active_debts_complaints, :active_debts
    remove_foreign_key :active_debts_complaints, :complaints
    remove_index :active_debts_complaints, :active_debt_id
    remove_index :active_debts_complaints, :complaint_id
    drop_table :active_debts_complaints
  end
end
