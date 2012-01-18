class CreateActiveDebtsComplaintsAgain < ActiveRecord::Migration
  def change
    create_table :active_debts_complaints, :id => false do |t|
      t.integer :complaint_id
      t.integer :active_debt_id
    end

    add_index :active_debts_complaints, :complaint_id
    add_index :active_debts_complaints, :active_debt_id
    add_foreign_key :active_debts_complaints, :complaints
    add_foreign_key :active_debts_complaints, :active_debts
  end
end
