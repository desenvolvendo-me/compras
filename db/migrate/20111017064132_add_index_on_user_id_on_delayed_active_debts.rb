class AddIndexOnUserIdOnDelayedActiveDebts < ActiveRecord::Migration
  def change
    add_index :delayed_active_debts, :user_id
  end
end
