class RemovePaymentStates < ActiveRecord::Migration
  def change
    drop_table :payment_states
  end
end
