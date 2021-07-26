class RenameColumnIsTradingToLicitationProcess < ActiveRecord::Migration
  def change
    rename_column :compras_licitation_processes, :is_trading, :eletronic_trading
  end
end
