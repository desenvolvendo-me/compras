class AddEnrolledFlagToDelayedActiveDebt < ActiveRecord::Migration
  def change
    add_column :delayed_active_debts, :enrolled, :boolean, :default => false 
  end
end
