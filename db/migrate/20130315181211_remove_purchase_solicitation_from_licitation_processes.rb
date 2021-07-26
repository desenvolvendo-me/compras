class RemovePurchaseSolicitationFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :purchase_solicitation_id
  end
end
