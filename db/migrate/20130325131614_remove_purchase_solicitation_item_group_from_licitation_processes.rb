class RemovePurchaseSolicitationItemGroupFromLicitationProcesses < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_processes, :purchase_solicitation_item_group_id
  end
end
