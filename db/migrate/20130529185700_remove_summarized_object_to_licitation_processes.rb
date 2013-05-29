class RemoveSummarizedObjectToLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :summarized_object
  end
end
