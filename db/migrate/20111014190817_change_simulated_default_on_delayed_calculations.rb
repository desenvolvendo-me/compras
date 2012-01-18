class ChangeSimulatedDefaultOnDelayedCalculations < ActiveRecord::Migration
  def up
    change_column_default :delayed_calculations, :simulated, false
  end

  def down
    change_column_default :delayed_calculations, :simulated, nil
  end
end
