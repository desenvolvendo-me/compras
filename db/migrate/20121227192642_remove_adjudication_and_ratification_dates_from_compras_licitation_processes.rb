class RemoveAdjudicationAndRatificationDatesFromComprasLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :adjudication_date
    remove_column :compras_licitation_processes, :ratification_date
  end
end
