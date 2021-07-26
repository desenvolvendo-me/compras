class AddTotalValueOfItemsToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :total_value_of_items, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
