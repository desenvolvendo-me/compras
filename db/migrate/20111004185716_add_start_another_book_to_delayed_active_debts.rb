class AddStartAnotherBookToDelayedActiveDebts < ActiveRecord::Migration
  def change
    add_column :delayed_active_debts, :start_another_book, :boolean
  end
end
