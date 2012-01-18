class RenameTableFromPaymentTypesToPaymentStates < ActiveRecord::Migration
  def change
    rename_table :payment_types, :payment_states
  end
end
