class ChangeDelayedCalculationsSimulatedDefaultToTrue < ActiveRecord::Migration
  def up
    change_column_default :delayed_calculations, :simulated, true
  end

  def down
    change_column_default :delayed_calculations, :simulated, false
  end
end
