class AddIndexOnUserIdOnDelayedCalculations < ActiveRecord::Migration
  def change
    add_index :delayed_calculations, :user_id
  end
end
