class AddUserIdToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :user_id, :integer
    add_foreign_key :delayed_calculations, :users
  end
end
