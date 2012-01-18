class RemoveOriginAndStatusFromDelayedCalculation < ActiveRecord::Migration
  def up
    remove_column :delayed_calculations, :origin
    remove_column :delayed_calculations, :status
  end

  def down
    add_column :delayed_calculations, :origin, :integer
    add_column :delayed_calculations, :status, :integer
  end
end
