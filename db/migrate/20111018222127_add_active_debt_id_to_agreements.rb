class AddActiveDebtIdToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :active_debt_id, :integer
    add_index :agreements, :active_debt_id
    add_foreign_key :agreements, :active_debts
  end
end
