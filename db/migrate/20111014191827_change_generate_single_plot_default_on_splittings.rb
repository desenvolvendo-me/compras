class ChangeGenerateSinglePlotDefaultOnSplittings < ActiveRecord::Migration
  def up
    change_column_default :splittings, :generate_single_plot, false
  end

  def down
    change_column_default :splittings, :generate_single_plot, nil
  end
end
