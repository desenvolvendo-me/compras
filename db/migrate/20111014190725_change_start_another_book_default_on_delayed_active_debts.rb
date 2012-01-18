class ChangeStartAnotherBookDefaultOnDelayedActiveDebts < ActiveRecord::Migration
  def up
    change_column_default :delayed_active_debts, :start_another_book, false
  end

  def down
    change_column_default :delayed_active_debts, :start_another_book, nil
  end
end
