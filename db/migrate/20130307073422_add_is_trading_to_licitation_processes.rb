class AddIsTradingToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :is_trading, :boolean, :default => false
  end
end
