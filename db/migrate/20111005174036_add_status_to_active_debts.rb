class AddStatusToActiveDebts < ActiveRecord::Migration
  def change
    add_column :active_debts, :status, :string
    add_index  :active_debts, :status
  end
end
